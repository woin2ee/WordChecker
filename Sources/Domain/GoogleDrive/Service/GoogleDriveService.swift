#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import Foundation
import FoundationPlus
import GoogleSignIn
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Drive
import RxSwift
import RxSwiftSugar
import Utility

public final class GoogleDriveService: GoogleDriveServiceProtocol {

    let gidSignIn: GIDSignIn

    init(gidSignIn: GIDSignIn) {
        self.gidSignIn = gidSignIn
    }

    public func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
#if os(macOS)
        guard let presentingViewController = presenting.window as? NSWindow else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }
#elseif os(iOS)
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }
#endif

        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            assertionFailure("ClientID is missing from info.plist")
            return .error(GoogleDriveServiceError.noClientID)
        }

        let config: GIDConfiguration = .init(clientID: clientID)

        return .create { result in
            self.gidSignIn.signIn(
                with: config,
                presenting: presentingViewController,
                hint: nil,
                additionalScopes: [ScopeCode.appData]
            ) { user, error in
                if error != nil || user == nil {
                    result(.failure(GoogleDriveServiceError.failedSignIn))
                } else {
                    result(.success(()))
                }
            }

            return Disposables.create()
        }
    }

    public func signOut() {
        gidSignIn.signOut()
    }

    public var hasSigned: Bool {
        return gidSignIn.currentUser != nil
    }

    public func restorePreviousSignIn() -> Single<Void> {
        return .create { result in
            self.gidSignIn.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    result(.failure(GoogleDriveServiceError.failedRestorePreviousSignIn))
                } else {
                    result(.success(()))
                }
            }

            return Disposables.create()
        }
    }

    public func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> Single<Void> {
#if os(macOS)
        guard let presentingViewController = presenting.window as? NSWindow else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }
#elseif os(iOS)
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }
#endif

        return .create { result in
            self.gidSignIn.addScopes([ScopeCode.appData], presenting: presentingViewController) { user, error in
                if error != nil || user == nil {
                    result(.failure(GoogleDriveServiceError.denyAccess))
                } else {
                    result(.success(()))
                }
            }

            return Disposables.create()
        }
    }

    public var isGrantedAppDataScope: Bool {
        guard let currentUser = gidSignIn.currentUser,
              let grantedScopes = currentUser.grantedScopes else {
            return false
        }

        return grantedScopes.contains(where: { $0 == ScopeCode.appData })
    }
    
    public func uploadBackupFile(_ backupFile: BackupFile) -> Single<Void> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }
        
        let file: GTLRDrive_File = .init()
        file.name = backupFile.name
        file.parents = [Space.appDataFolder.rawValue]
        
        return .create { observer in
            Task {
                try await GoogleDriveAPI(authentication: currentUser.authentication).files.create(file, with: backupFile.data)
                observer(.success(()))
            } catch: {
                observer(.failure($0))
            }
            
            return Disposables.create()
        }
    }
    
    public func downloadLatestBackupFile(backupFileName: String) -> Single<BackupFile> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }
        
        return .create { observer in
            Task {
                let backupFileList = try await self.fetchBackupFileList(backupFileName: backupFileName)
                
                guard let backupFileID = backupFileList.files?.first?.identifier else {
                    observer(.failure(GoogleDriveServiceError.noFileInDrive))
                    return
                }
                
                let dataObject = try await GoogleDriveAPI(authentication: currentUser.authentication).files.get(forFileID: backupFileID)

                observer(.success(BackupFile(name: backupFileName, data: dataObject.data)))
            } catch: {
                observer(.failure($0))
            }
            
            return Disposables.create()
        }
    }
    
    public func deleteBackupFiles(backupFileName: String) -> Single<Void> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }
        
        return .create { observer in
            Task {
                let backupFileList = try await self.fetchBackupFileList(backupFileName: backupFileName)
                
                guard let backupFiles = backupFileList.files else {
                    observer(.success(()))
                    return
                }
                
                try await backupFiles.compactMap(\.identifier)
                    .asyncForEach {
                        try await GoogleDriveAPI(authentication: currentUser.authentication).files.delete(byFileID: $0)
                    }
                
                observer(.success(()))
            } catch: {
                observer(.failure($0))
            }
            
            return Disposables.create()
        }
    }
}

// MARK: Helpers

extension GoogleDriveService {
    
    private func fetchBackupFileList(backupFileName: String) async throws -> GTLRDrive_FileList {
        guard let currentUser = gidSignIn.currentUser else {
            throw GoogleDriveServiceError.noSignedInUser
        }

        let filesListQuery: GTLRDriveQuery_FilesList = .query()
        filesListQuery.q = "name = '\(backupFileName)' and trashed = false"
        filesListQuery.spaces = Space.appDataFolder.rawValue

        return try await GoogleDriveAPI(authentication: currentUser.authentication).files.list(query: filesListQuery)
    }
}

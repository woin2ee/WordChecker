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
import UtilitySource

public final class DefaultGoogleDriveService: GoogleDriveService {

    private let gidSignIn: GIDSignIn

    init(gidSignIn: GIDSignIn) {
        self.gidSignIn = gidSignIn
    }

    public func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Email?> {
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
                if let error = error {
                    result(.failure(error))
                    return
                }
                
                guard let user = user else {
                    result(.failure(GoogleDriveServiceError.failedSignIn))
                    return
                }
                
                result(.success(user.profile?.email))
            }

            return Disposables.create()
        }
    }

    public func signOut() {
        gidSignIn.signOut()
    }
    
    public var currentUserEmail: Email? {
        gidSignIn.currentUser?.profile?.email
    }

    public var hasSigned: Bool {
        return gidSignIn.currentUser != nil
    }

    public func restorePreviousSignIn() -> Single<Email?> {
        return .create { result in
            self.gidSignIn.restorePreviousSignIn { user, error in
                if let error = error {
                    result(.failure(error))
                    return
                }
                
                guard let user = user else {
                    result(.failure(GoogleDriveServiceError.failedRestorePreviousSignIn))
                    return
                }
                
                result(.success(user.profile?.email))
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
        file.name = backupFile.name.rawValue
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

    public func downloadLatestBackupFile(backupFileName: BackupFileName) -> Single<BackupFile> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        return .create { observer in
            let task = Task {
                try Task.checkCancellation()
                let backupFileList = try await self.fetchBackupFileList(backupFileName: backupFileName.rawValue)

                guard let backupFileID = backupFileList.files?.first?.identifier else {
                    observer(.failure(GoogleDriveServiceError.noFileInDrive))
                    return
                }

                try Task.checkCancellation()
                let api = GoogleDriveAPI(authentication: currentUser.authentication)
                let dataObject = try await api.files.get(forFileID: backupFileID)

                observer(.success(BackupFile(name: backupFileName, data: dataObject.data)))
            } catch: {
                observer(.failure($0))
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }

    public func deleteAllBackupFiles(named backupFileName: BackupFileName) -> Single<Void> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        return .create { observer in
            let task = Task {
                try Task.checkCancellation()
                let backupFileList = try await self.fetchBackupFileList(backupFileName: backupFileName.rawValue)

                guard let backupFiles = backupFileList.files else {
                    observer(.success(()))
                    return
                }

                try Task.checkCancellation()
                let api = GoogleDriveAPI(authentication: currentUser.authentication)
                try await backupFiles.compactMap(\.identifier)
                    .asyncForEach {
                        try await api.files.delete(byFileID: $0)
                    }

                observer(.success(()))
            } catch: {
                observer(.failure($0))
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: Helpers

extension DefaultGoogleDriveService {

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

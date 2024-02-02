import Domain
import Foundation
import GoogleSignIn
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Drive
import RxSwift
import UIKit
import Utility

enum GoogleDriveServiceError: Error {

    /// 로그인 복구 실패
    case failedRestorePreviousSignIn

    /// 로그인 실패
    case failedSignIn

    /// 로그인 화면 제시가 불가능한 윈도우
    case unSupportedWindow

    case noClientID

    case denyAccess

    /// 로그인 되어있지 않음
    case noSignedInUser

    /// 구글 드라이브에 파일이 없음
    case noFileInDrive

}

final class GoogleDriveService: Domain.GoogleDriveService {

    let gidSignIn: GIDSignIn

    let backupFileName = "word_list_backup"

    init(gidSignIn: GIDSignIn) {
        self.gidSignIn = gidSignIn
    }

    func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }

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

    func signOut() {
        gidSignIn.signOut()
    }

    var hasSigned: Bool {
        return gidSignIn.currentUser != nil
    }

    func restorePreviousSignIn() -> Single<Void> {
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

    func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> Single<Void> {
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveServiceError.unSupportedWindow)
        }

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

    var isGrantedAppDataScope: Bool {
        guard let currentUser = gidSignIn.currentUser,
              let grantedScopes = currentUser.grantedScopes else {
            return false
        }

        return grantedScopes.contains(where: { $0 == ScopeCode.appData })
    }

    func uploadWordList(_ wordList: [Domain.Word]) -> RxSwift.Single<Void> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        guard let data = try? JSONEncoder().encode(wordList) else {
            return .error(EncodingError.invalidValue(wordList, .init(codingPath: [], debugDescription: "")))
        }

        let file: GTLRDrive_File = .init()
        file.name = backupFileName
        file.parents = ["appDataFolder"]

        let fileCreatingSequence: Single<Void> = .create { result in
            Task {
                try await GoogleDriveAPI(user: currentUser).create(for: file, with: data)
                result(.success(()))
            } catch: {
                result(.failure($0))
            }

            return Disposables.create()
        }

        return deleteBackupFiles()
            .catchAndThenJustNext()
            .flatMap { return fileCreatingSequence }
    }

    func downloadWordList() -> RxSwift.Single<[Domain.Word]> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        return .create { result in
            Task {
                let fileList = try await self.backupFiles

                guard let backupFileID = fileList.files?.first?.identifier else {
                    result(.failure(GoogleDriveServiceError.noFileInDrive))
                    return
                }

                let dataObject = try await GoogleDriveAPI(user: currentUser).files(forFileID: backupFileID)
                let decoded = try JSONDecoder().decode([Domain.Word].self, from: dataObject.data)

                result(.success(decoded))
            } catch: {
                result(.failure($0))
            }

            return Disposables.create()
        }
    }

    private func deleteBackupFiles() -> Completable {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveServiceError.noSignedInUser)
        }

        return .create { observer in
            Task {
                let fileList = try await self.backupFiles

                guard let backupFiles = fileList.files else {
                    observer(.completed)
                    return
                }

                try await backupFiles.compactMap(\.identifier)
                    .asyncForEach {
                        try await GoogleDriveAPI(user: currentUser).delete(byFileID: $0)
                    }

                observer(.completed)
            } catch: {
                observer(.error($0))
            }

            return Disposables.create()
        }
    }

    private var backupFiles: GTLRDrive_FileList {
        get async throws {
            guard let currentUser = gidSignIn.currentUser else {
                throw GoogleDriveServiceError.noSignedInUser
            }

            let filesListQuery: GTLRDriveQuery_FilesList = .query()
            filesListQuery.q = "name = '\(backupFileName)' and trashed = false"
            filesListQuery.spaces = "appDataFolder"

            return try await GoogleDriveAPI(user: currentUser).filesList(query: filesListQuery)
        }
    }

}

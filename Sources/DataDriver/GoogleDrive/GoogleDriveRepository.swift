//
//  GoogleDriveRepository.swift
//  GoogleDrivePlatform
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import GoogleSignIn
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Drive
import RxSwift
import UIKit

public final class GoogleDriveRepository: GoogleDriveRepositoryProtocol {

    let gidSignIn: GIDSignIn

    let backupFileName = "word_list_backup"

    public init(gidSignIn: GIDSignIn) {
        self.gidSignIn = gidSignIn
    }

    public func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveRepositoryError.unSupportedWindow)
        }

        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            assertionFailure("ClientID is missing from info.plist")
            return .error(GoogleDriveRepositoryError.noClientID)
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
                    result(.failure(GoogleDriveRepositoryError.failedSignIn))
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
                    result(.failure(GoogleDriveRepositoryError.failedRestorePreviousSignIn))
                } else {
                    result(.success(()))
                }
            }

            return Disposables.create()
        }
    }

    public func requestAccess(presenting: PresentingConfiguration) -> Single<Void> {
        guard let presentingViewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveRepositoryError.unSupportedWindow)
        }

        return .create { result in
            self.gidSignIn.addScopes([ScopeCode.appData], presenting: presentingViewController) { user, error in
                if error != nil || user == nil {
                    result(.failure(GoogleDriveRepositoryError.denyAccess))
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

    public func uploadWordList(_ wordList: [Domain.Word]) -> RxSwift.Single<Void> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveRepositoryError.noSignedInUser)
        }

        guard let data = try? JSONEncoder().encode(wordList) else {
            return .error(EncodingError.invalidValue(wordList, .init(codingPath: [], debugDescription: "")))
        }

        let file: GTLRDrive_File = .init()
        file.name = backupFileName
        file.parents = ["appDataFolder"]

        return .create { result in
            Task {
                do {
                    try await GoogleDriveAPI(user: currentUser).create(for: file, with: data)
                    result(.success(()))
                } catch {
                    result(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    public func downloadWordList() -> RxSwift.Single<[Domain.Word]> {
        guard let currentUser = gidSignIn.currentUser else {
            return .error(GoogleDriveRepositoryError.noSignedInUser)
        }

        let service: GTLRDriveService = .init()
        service.authorizer = currentUser.authentication.fetcherAuthorizer()

        let filesListQuery: GTLRDriveQuery_FilesList = .query()
        filesListQuery.q = "name = '\(backupFileName)' and trashed = false"
        filesListQuery.spaces = "appDataFolder"

        let api = GoogleDriveAPI(user: currentUser)

        return .create { result in
            Task {
                do {
                    let fileList = try await api.filesList(query: filesListQuery)

                    guard let backupFileID = fileList.files?.first?.identifier else {
                        result(.failure(GoogleDriveRepositoryError.noFileInDrive))
                        return
                    }

                    let dataObject = try await api.files(forFileID: backupFileID)
                    let decoded = try JSONDecoder().decode([Domain.Word].self, from: dataObject.data)

                    result(.success(decoded))
                } catch {
                    result(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

}

enum GoogleDriveRepositoryError: Error {

    case failedRestorePreviousSignIn

    case failedSignIn

    case unSupportedWindow

    case noClientID

    case denyAccess

    case noSignedInUser

    case noFileInDrive

}

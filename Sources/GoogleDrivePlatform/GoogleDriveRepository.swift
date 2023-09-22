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
import RxSwift
import UIKit

public final class GoogleDriveRepository: GoogleDriveRepositoryProtocol {

    let gidSignIn: GIDSignIn

    public init(gidSignIn: GIDSignIn) {
        self.gidSignIn = gidSignIn
    }

    public func signIn(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            assertionFailure("ClientID is missing from info.plist")
            return .error(GoogleDriveRepositoryError.noClientID)
        }

        let config: GIDConfiguration = .init(clientID: clientID)

        guard let viewController = presenting.window as? UIViewController else {
            return .error(GoogleDriveRepositoryError.unSupportedWindow)
        }

        return .create { result in
            self.gidSignIn.signIn(with: config, presenting: viewController) { user, error in
                if error != nil, user == nil {
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

    public var hasSignIn: Bool {
        return gidSignIn.currentUser != nil
    }

    public func restorePreviousSignIn() -> Result<Void, Error> {
        gidSignIn.restorePreviousSignIn()

        if gidSignIn.currentUser != nil {
            return .success(())
        } else {
            return .failure(GoogleDriveRepositoryError.failedRestorePreviousSignIn)
        }
    }

    public func uploadWordList(_ wordList: [Domain.Word]) -> RxSwift.Single<Void> {
        // GoogleDrive 저장
        fatalError("Not implemented.")
    }

    public func downloadWordList() -> RxSwift.Single<[Domain.Word]> {
        // GoogleDrive 가져오기
        fatalError("Not implemented.")
    }

}

enum GoogleDriveRepositoryError: Error {

    case failedRestorePreviousSignIn

    case failedSignIn

    case unSupportedWindow

    case noClientID

}

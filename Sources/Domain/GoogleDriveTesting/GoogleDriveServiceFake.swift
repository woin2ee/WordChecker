//
//  GoogleDriveServiceFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain_GoogleDrive
import Foundation
import RxSwift

public final class GoogleDriveServiceFake {

//    public var _wordList: [Word] = []

    public var _hasSignIn: Bool = false

    public var _isGrantedAppDataScope: Bool = false

//    public init(sampleWordList: [Word] = []) {
//        _wordList = sampleWordList
//    }

//    public func uploadWordList(_ wordList: [Word]) -> Single<Void> {
//        if _hasSignIn == false {
//            return .error(GoogleDriveRepositoryFakeError.noSignedIn)
//        }
//
//        if _isGrantedAppDataScope == false {
//            return .error(GoogleDriveRepositoryFakeError.noGranted)
//        }
//
//        _wordList = wordList
//
//        return .just(())
//    }
//
//    public func downloadWordList() -> Single<[Word]> {
//        if _hasSignIn == false {
//            return .error(GoogleDriveRepositoryFakeError.noSignedIn)
//        }
//
//        if _isGrantedAppDataScope == false {
//            return .error(GoogleDriveRepositoryFakeError.noGranted)
//        }
//
//        return .just(_wordList)
//    }

    public func signInWithAppDataScope(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        _hasSignIn = true
        _isGrantedAppDataScope = true

        return .just(())
    }

    public func signOut() {
        _hasSignIn = false
        _isGrantedAppDataScope = false
    }

    public var hasSigned: Bool {
        _hasSignIn
    }

    public var isGrantedAppDataScope: Bool {
        _isGrantedAppDataScope
    }

    public func restorePreviousSignIn() -> RxSwift.Single<Void> {
        _hasSignIn = true

        return .just(())
    }

    public func requestAppDataScopeAccess(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        if _hasSignIn == false {
            return .error(GoogleDriveRepositoryFakeError.noSignedIn)
        }

        _isGrantedAppDataScope = true

        return .just(())
    }

}

enum GoogleDriveRepositoryFakeError: Error {

    case noSignedIn

    case noGranted

}

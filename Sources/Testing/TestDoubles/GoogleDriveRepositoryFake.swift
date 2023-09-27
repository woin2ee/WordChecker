//
//  GoogleDriveRepositoryFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import RxSwift
import Foundation

public final class GoogleDriveRepositoryFake: GoogleDriveRepositoryProtocol {

    public var _wordList: [Word] = []

    public var _hasSignIn: Bool = false

    public var _isGrantedAppDataScope: Bool = false

    public init(sampleWordList: [Word] = []) {
        _wordList = sampleWordList
    }

    public func uploadWordList(_ wordList: [Word]) -> Single<Void> {
        if _hasSignIn == false || _isGrantedAppDataScope == false {
            return .error(TestingError.testingError)
        }

        _wordList = wordList

        return .just(())
    }

    public func downloadWordList() -> Single<[Word]> {
        if _hasSignIn == false || _isGrantedAppDataScope == false {
            return .error(TestingError.testingError)
        }

        return .just(_wordList)
    }

    public func signInWithAppDataScope(presenting: Domain.PresentingConfiguration) -> RxSwift.Single<Void> {
        _hasSignIn = true
        _isGrantedAppDataScope = true

        return .just(())
    }

    public func signOut() {
        _hasSignIn = false
        _isGrantedAppDataScope = false
    }

    public var hasSignIn: Bool {
        _hasSignIn
    }

    public var isGrantedAppDataScope: Bool {
        _isGrantedAppDataScope
    }

    public func restorePreviousSignIn() -> Result<Void, Error> {
        _hasSignIn = true

        return .success(())
    }

    public func requestAccess(presenting: Domain.PresentingConfiguration) -> RxSwift.Single<Void> {
        if _hasSignIn == false {
            return .error(TestingError.testingError)
        }

        _isGrantedAppDataScope = true

        return .just(())
    }

}

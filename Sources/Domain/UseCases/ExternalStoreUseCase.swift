//
//  ExternalStoreUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxUtility

public final class ExternalStoreUseCase: ExternalStoreUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol
    let googleDriveRepository: GoogleDriveRepositoryProtocol
    let unmemorizedWordListState: UnmemorizedWordListStateProtocol

    public init(
        wordRepository: WordRepositoryProtocol,
        googleDriveRepository: GoogleDriveRepositoryProtocol,
        unmemorizedWordListState: UnmemorizedWordListStateProtocol
    ) {
        self.wordRepository = wordRepository
        self.googleDriveRepository = googleDriveRepository
        self.unmemorizedWordListState = unmemorizedWordListState
    }

    public func signIn(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        if hasSignIn {
            return .just(())
        }

        let result = googleDriveRepository.restorePreviousSignIn()

        do {
            try result.get()
            return .just(())
        } catch {
            return self.googleDriveRepository.signIn(presenting: presenting)
        }
    }

    public func signOut() {
        googleDriveRepository.signOut()
    }

    public var hasSignIn: Bool {
        return googleDriveRepository.hasSignIn
    }

    public func restorePreviousSignIn() -> Result<Void, Error> {
        return googleDriveRepository.restorePreviousSignIn()
    }

    /// - Parameter presenting: 구글 드라이브 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    public func upload(presenting: PresentingConfiguration?) -> Single<Void> {
        func doUpload() -> Single<Void> {
            let wordList = wordRepository.getAll()
            return googleDriveRepository.uploadWordList(wordList)
        }

        if hasSignIn {
            return doUpload()
        }

        guard let presenting = presenting else {
            return .error(ExternalStoreUseCaseError.noPresentingConfiguration)
        }

        return signIn(presenting: presenting)
            .flatMap { doUpload() }
    }

    /// - Parameter presenting: 구글 드라이브 로그인이 되어있지 않을 때 로그인 화면을 제시하는데 사용되는 구성
    public func download(presenting: PresentingConfiguration?) -> Single<Void> {
        func doDownload() -> Single<Void> {
            return googleDriveRepository.downloadWordList()
                .doOnSuccess { wordList in
                    self.wordRepository.reset(to: wordList)
                    self.unmemorizedWordListState.randomizeList(with: wordList)
                }
                .mapToVoid()
        }

        if hasSignIn {
            return doDownload()
        }

        guard let presenting = presenting else {
            return .error(ExternalStoreUseCaseError.noPresentingConfiguration)
        }

        return signIn(presenting: presenting)
            .flatMap { doDownload() }
    }

}

enum ExternalStoreUseCaseError: Error {

    case noCurrentUser

    case noPresentingConfiguration

}

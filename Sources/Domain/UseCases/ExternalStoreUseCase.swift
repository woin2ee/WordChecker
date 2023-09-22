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

    public func upload(presenting: PresentingConfiguration) -> Single<Void> {
        func doUpload() -> Single<Void> {
            let wordList = wordRepository.getAll()
            return googleDriveRepository.uploadWordList(wordList)
        }

        if hasSignIn {
            return doUpload()
        } else {
            return signIn(presenting: presenting)
                .flatMap { doUpload() }
        }
    }

    public func download(presenting: PresentingConfiguration) -> Single<Void> {
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
        } else {
            return signIn(presenting: presenting)
                .flatMap { doDownload() }
        }
    }

}

enum ExternalStoreUseCaseError: Error {

    case noCurrentUser

}

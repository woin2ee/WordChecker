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

    public func upload() -> Single<Void> {
        let wordList = wordRepository.getAll()

        guard hasSignIn else { return .error(ExternalStoreUseCaseError.noCurrentUser) }

        return googleDriveRepository.uploadWordList(wordList)
    }

    public func download() -> Single<Void> {
        guard hasSignIn else { return .error(ExternalStoreUseCaseError.noCurrentUser) }

        return googleDriveRepository.downloadWordList()
            .doOnSuccess { wordList in
                self.wordRepository.reset(to: wordList)
                self.unmemorizedWordListState.randomizeList(with: wordList)
            }
            .mapToVoid()
    }

}

enum ExternalStoreUseCaseError: Error {

    case noCurrentUser

}

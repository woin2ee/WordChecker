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

    public func upload() -> Single<Void> {
        let wordList = wordRepository.getAll()
        return googleDriveRepository.uploadWordList(wordList)
    }

    public func download() -> Single<Void> {
        return googleDriveRepository.downloadWordList()
            .doOnSuccess { wordList in
                self.wordRepository.reset(to: wordList)
                self.unmemorizedWordListState.randomizeList(with: wordList)
            }
            .mapToVoid()
    }

}

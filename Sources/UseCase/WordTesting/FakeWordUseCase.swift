//
//  FakeWordUseCase.swift
//  UseCase_WordTesting
//
//  Created by Jaewon Yun on 5/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_LocalNotification
import Domain_LocalNotificationTesting
import Domain_WordManagement
import Domain_WordManagementTesting
import Domain_WordMemorization
import Domain_WordMemorizationTesting
import Foundation
import RxSwift
@testable import UseCase_Word

public final class FakeWordUseCase: WordUseCase {
    
    private let _wordUseCase: WordUseCase
    
    public init(
        wordManagementService: WordManagementService = FakeWordManagementService(),
        wordMemorizationService: WordMemorizationService = FakeWordMemorizationService.fake(),
        localNotificationService: LocalNotificationService = LocalNotificationServiceFake()
    ) {
        self._wordUseCase = DefaultWordUseCase(
            wordManagementService: wordManagementService,
            wordMemorizationService: wordMemorizationService,
            localNotificationService: localNotificationService
        )
    }
    
    public func addNewWord(_ word: String) -> RxSwift.Single<Void> {
        _wordUseCase.addNewWord(word)
    }
    
    public func deleteWord(by uuid: UUID) -> RxSwift.Single<Void> {
        return _wordUseCase.deleteWord(by: uuid)
    }

    public func fetchWordList() -> [Domain_WordManagement.Word] {
        return _wordUseCase.fetchWordList()
    }

    public func fetchMemorizedWordList() -> [Domain_WordManagement.Word] {
        return _wordUseCase.fetchMemorizedWordList()
    }

    public func fetchMemorizingWordList() -> [Domain_WordManagement.Word] {
        return _wordUseCase.fetchMemorizingWordList()
    }
    
    public func fetchMemorizingWordList() -> RxSwift.Infallible<[Domain_WordManagement.Word]> {
        return _wordUseCase.fetchMemorizingWordList()
    }

    public func fetchWord(by uuid: UUID) -> RxSwift.Single<Domain_WordManagement.Word> {
        return _wordUseCase.fetchWord(by: uuid)
    }

    public func updateWord(by uuid: UUID, with newAttribute: Domain_WordManagement.WordAttribute) -> RxSwift.Single<Void> {
        return _wordUseCase.updateWord(by: uuid, with: newAttribute)
    }

    public func shuffleUnmemorizedWordList() {
        _wordUseCase.shuffleUnmemorizedWordList()
    }

    public func updateToNextWord() -> Domain_WordMemorization.MemorizingWord? {
        return _wordUseCase.updateToNextWord()
    }

    public func updateToPreviousWord() -> Domain_WordMemorization.MemorizingWord? {
        return _wordUseCase.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized() -> RxSwift.Single<Void> {
        return _wordUseCase.markCurrentWordAsMemorized()
    }

    public func markWordsAsMemorized(by uuids: [UUID]) -> RxSwift.Single<Void> {
        return _wordUseCase.markWordsAsMemorized(by: uuids)
    }

    public func getCurrentUnmemorizedWord() -> (word: Domain_WordMemorization.MemorizingWord?, index: Int?) {
        return _wordUseCase.getCurrentUnmemorizedWord()
    }

    public func isWordDuplicated(_ word: String) -> RxSwift.Single<Bool> {
        return _wordUseCase.isWordDuplicated(word)
    }

    public func getCheckedCount() -> Int {
        return _wordUseCase.getCheckedCount()
    }
    
    public func getCheckedCount() -> RxSwift.Infallible<Int> {
        return _wordUseCase.getCheckedCount()
    }
    
    public func initializeMemorizingList() {
        _wordUseCase.initializeMemorizingList()
    }
}

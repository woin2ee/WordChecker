//
//  WordUseCaseFake.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/12.
//

@testable import Domain

import Foundation
import InfrastructureTesting
import RxSwift
import RxUtility
import Utility

public final class WordUseCaseFake: WordUseCaseProtocol {

    public var _wordList: [Domain.Word] = []

    public var _unmemorizedWordList: UnmemorizedWordListRepositorySpy = .init()

    public init() {}

    public func addNewWord(_ word: Domain.Word) -> Single<Void> {
        _wordList.append(word)
        _unmemorizedWordList.addWord(word)
        return .just(())
    }

    public func deleteWord(by uuid: UUID) -> Single<Void> {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList.remove(at: index)
        }
        _unmemorizedWordList.deleteWord(by: uuid)
        return .just(())
    }

    public func getWordList() -> Single<[Domain.Word]> {
        return .just(_wordList)
    }

    public func getMemorizedWordList() -> Single<[Domain.Word]> {
        let memorizedList = _wordList.filter { $0.memorizedState == .memorized }
        return .just(memorizedList)
    }

    public func getUnmemorizedWordList() -> Single<[Domain.Word]> {
        let memorizingList = _wordList.filter { $0.memorizedState == .memorizing }
        return .just(memorizingList)
    }

    public func getWord(by uuid: UUID) -> Single<Domain.Word> {
        guard let word = _wordList.first(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.invalidUUID(uuid))
        }
        return .just(word)
    }

    public func updateWord(by uuid: UUID, to newWord: Domain.Word) -> Single<Void> {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index] = newWord
        }
        _unmemorizedWordList.replaceWord(where: uuid, with: newWord)
        return .just(())
    }

    public func shuffleUnmemorizedWordList() -> Single<Void> {
        return getUnmemorizedWordList()
            .doOnSuccess { wordList in
                self._unmemorizedWordList.shuffle(with: wordList)
            }
            .mapToVoid()
    }

    public func updateToNextWord() -> Single<Void> {
        _unmemorizedWordList.updateToNextWord()
        return .just(())
    }

    public func updateToPreviousWord() -> Single<Void> {
        _unmemorizedWordList.updateToPreviousWord()
        return .just(())
    }

    public func markCurrentWordAsMemorized(uuid: UUID) -> Single<Void> {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index].memorizedState = .memorized
        }
        _unmemorizedWordList.deleteWord(by: uuid)
        return .just(())
    }

    public func getCurrentUnmemorizedWord() -> Single<Domain.Word> {
        guard let currentWord = _unmemorizedWordList.getCurrentWord() else {
            return .error(WordUseCaseError.noMemorizingWords)
        }
        return .just(currentWord)
    }

}

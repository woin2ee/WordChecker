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

    /// Fake 객체 구현을 위해 사용한 인메모리 단어 저장소
    public var _wordList: [Domain.Word] = []

    public var _unmemorizedWordList: UnmemorizedWordListRepositorySpy = .init()

    public init() {}

    public func addNewWord(_ word: Domain.Word) -> Single<Void> {
        if _wordList.contains(where: { $0.word.lowercased() == word.word.lowercased() }) {
            return .error(WordUseCaseError.saveFailed(reason: .duplicatedWord(word: word.word)))
        }

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
            return .error(WordUseCaseError.retrieveFailed(reason: .uuidInvaild(uuid: uuid)))
        }
        return .just(word)
    }

    public func updateWord(by uuid: UUID, to newWord: Domain.Word) -> Single<Void> {
        guard let index = _wordList.firstIndex(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.retrieveFailed(reason: .uuidInvaild(uuid: uuid)))
        }

        if (newWord.word.lowercased() != _wordList[index].word.lowercased()) &&
            _wordList.contains(where: { $0.word.lowercased() == newWord.word.lowercased() }) {
            return .error(WordUseCaseError.saveFailed(reason: .duplicatedWord(word: newWord.word)))
        }

        let updateTarget: Word = .init(
            uuid: uuid,
            word: newWord.word,
            memorizedState: newWord.memorizedState
        )

        if _unmemorizedWordList.contains(where: { $0.uuid == updateTarget.uuid }) {
            switch updateTarget.memorizedState {
            case .memorized:
                _unmemorizedWordList.deleteWord(by: uuid)
            case .memorizing:
                _unmemorizedWordList.replaceWord(where: uuid, with: updateTarget)
            }
        } else if updateTarget.memorizedState == .memorizing {
            _unmemorizedWordList.addWord(updateTarget)
        }

        _wordList[index] = updateTarget

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

    public func isWordDuplicated(_ word: String) -> Infallible<Bool> {
        if _wordList.contains(where: { $0.word.lowercased() == word.lowercased() }) {
            return .just(true)
        } else {
            return .just(false)
        }
    }

}

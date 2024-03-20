//
//  WordUseCaseFake.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/12.
//

@testable import Domain_Word
import Domain_WordTesting
import Foundation
import RxSwift
import RxSwiftSugar
import Utility
@testable import UseCase_Word

enum WordUseCaseFakeError: Error {
    case duplicatedWord
}

public final class WordUseCaseFake: WordUseCaseProtocol {

    /// Fake 객체 구현을 위해 사용한 인메모리 단어 저장소
    public var _wordList: [Word] = []

    public var _unmemorizedWordList: UnmemorizedWordListRepositorySpy = .init()

    public init() {}

    public func addNewWord(_ word: Word) -> Single<Void> {
        if _wordList.contains(where: { $0.word.lowercased() == word.word.lowercased() }) {
            return .error(WordUseCaseFakeError.duplicatedWord)
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

    public func fetchWordList() -> [Word] {
        return _wordList
    }

    public func fetchMemorizedWordList() -> [Word] {
        let memorizedList = _wordList.filter { $0.memorizedState == .memorized }
        return memorizedList
    }

    public func fetchUnmemorizedWordList() -> [Word] {
        let memorizingList = _wordList.filter { $0.memorizedState == .memorizing }
        return memorizingList
    }

    public func fetchWord(by uuid: UUID) -> Single<Word> {
        guard let word = _wordList.first(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.uuidInvalid)
        }
        return .just(word)
    }

    public func updateWord(by uuid: UUID, to newWord: Word) -> Single<Void> {
        guard let index = _wordList.firstIndex(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.uuidInvalid)
        }

        if (newWord.word.lowercased() != _wordList[index].word.lowercased()) &&
            _wordList.contains(where: { $0.word.lowercased() == newWord.word.lowercased() }) {
            return .error(WordUseCaseFakeError.duplicatedWord)
        }

        let updateTarget: Word
        do {
            updateTarget = try .init(
                uuid: uuid,
                word: newWord.word,
                memorizedState: newWord.memorizedState
            )
        } catch {
            return .error(error)
        }

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

    public func shuffleUnmemorizedWordList() {
        let unmemorizedWordList = fetchUnmemorizedWordList()
        _unmemorizedWordList.shuffle(with: unmemorizedWordList)
    }

    public func updateToNextWord() {
        _unmemorizedWordList.updateToNextWord()
    }

    public func updateToPreviousWord() {
        _unmemorizedWordList.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized(uuid: UUID) -> Single<Void> {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index].memorizedState = .memorized
        }
        _unmemorizedWordList.deleteWord(by: uuid)
        return .just(())
    }

    public func getCurrentUnmemorizedWord() -> Word? {
        return _unmemorizedWordList.getCurrentWord()
    }

    public func isWordDuplicated(_ word: String) -> Single<Bool> {
        if _wordList.contains(where: { $0.word.lowercased() == word.lowercased() }) {
            return .just(true)
        } else {
            return .just(false)
        }
    }

}

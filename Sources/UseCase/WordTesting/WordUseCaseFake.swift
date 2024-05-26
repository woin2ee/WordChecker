//
//  WordUseCaseFake.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/12.
//

@testable import Domain_WordManagement
import Foundation
import RxSwift
import RxSwiftSugar
import Utility
@testable import UseCase_Word

enum WordUseCaseFakeError: Error {
    case duplicatedWord
}

public final class WordUseCaseFake: WordUseCase {

    /// Fake 객체 구현을 위해 사용한 인메모리 단어 저장소
    private var _wordList: [Word] = []

    private var _unmemorizedWordList: UnmemorizedWordListRepository = .init()

    public init() {}

    public func addNewWord(_ word: String) -> Single<Void> {
        if _wordList.contains(where: { $0.word.lowercased() == word.lowercased() }) {
            return .error(WordUseCaseFakeError.duplicatedWord)
        }

        return .create { observer in
            do {
                let newWordEntity = try Word(word: word)

                self._wordList.append(newWordEntity)
                self._unmemorizedWordList.addWord(newWordEntity)

                observer(.success(()))
            } catch {
                observer(.failure(error))
            }

            return Disposables.create()
        }
    }

    /// For tests.
    public func addNewWord(_ word: Word) throws {
        if _wordList.contains(where: { $0.word.lowercased() == word.word.lowercased() }) {
            throw WordUseCaseFakeError.duplicatedWord
        }

        self._wordList.append(word)

        if word.memorizationState == .memorizing {
            self._unmemorizedWordList.addWord(word)
        }
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
        let memorizedList = _wordList.filter { $0.memorizationState == .memorized }
        return memorizedList
    }

    public func fetchUnmemorizedWordList() -> [Word] {
        let memorizingList = _wordList.filter { $0.memorizationState == .memorizing }
        return memorizingList
    }

    public func fetchWord(by uuid: UUID) -> Single<Word> {
        guard let word = _wordList.first(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.uuidInvalid)
        }
        return .just(word)
    }

    public func updateWord(by uuid: UUID, with newAttribute: WordAttribute) -> Single<Void> {
        guard let index = _wordList.firstIndex(where: { $0.uuid == uuid }) else {
            return .error(WordUseCaseError.uuidInvalid)
        }

        var wordEntity = _wordList[index]

        if let newWord = newAttribute.word {
            if (newWord.lowercased() != wordEntity.word.lowercased()) &&
                _wordList.contains(where: { $0.word.lowercased() == newWord.lowercased() }) {
                return .error(WordUseCaseFakeError.duplicatedWord)
            }
            do {
                try wordEntity.setWord(newWord)
            } catch {
                return .error(error)
            }
        }

        if let newState = newAttribute.memorizationState {
            wordEntity.memorizationState = newState
        }

        _wordList[index] = wordEntity

        if _unmemorizedWordList.contains(where: { $0.uuid == uuid }) {
            switch wordEntity.memorizationState {
            case .memorized:
                _unmemorizedWordList.deleteWord(by: uuid)
            case .memorizing:
                _unmemorizedWordList.replaceWord(where: uuid, with: wordEntity)
            }
        } else if wordEntity.memorizationState == .memorizing {
            _unmemorizedWordList.addWord(wordEntity)
        }

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

    public func markCurrentWordAsMemorized() -> Single<Void> {
        guard let uuid = _unmemorizedWordList.getCurrentWord()?.uuid else {
            return .just(())
        }
        
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index].memorizationState = .memorized
        }
        _unmemorizedWordList.deleteWord(by: uuid)
        return .just(())
    }
    
    public func markWordsAsMemorized(by uuids: [UUID]) -> RxSwift.Single<Void> {
        return .create { observer in
            uuids.forEach { uuid in
                if let index = self._wordList.firstIndex(where: { $0.uuid == uuid }) {
                    self._wordList[index].memorizationState = .memorized
                }
                self._unmemorizedWordList.deleteWord(by: uuid)
            }
            
            observer(.success(()))
            return Disposables.create()
        }
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

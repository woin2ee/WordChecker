//
//  WordUseCaseFake.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/12.
//

import DataDriverTesting
import Domain
import Foundation
import Utility

public final class WordUseCaseFake: WordUseCaseProtocol {

    public var _wordList: [Domain.Word] = []

    public var _unmemorizedWordList: UnmemorizedWordListRepositorySpy = .init()

    public init() {}

    public func addNewWord(_ word: Domain.Word) {
        _wordList.append(word)
        _unmemorizedWordList.addWord(word)
    }

    public func deleteWord(by uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList.remove(at: index)
        }
        _unmemorizedWordList.deleteWord(by: uuid)
    }

    public func getWordList() -> [Domain.Word] {
        return _wordList
    }

    public func getMemorizedWordList() -> [Domain.Word] {
        return _wordList.filter { $0.memorizedState == .memorized }
    }

    public func getUnmemorizedWordList() -> [Domain.Word] {
        return _wordList.filter { $0.memorizedState == .memorizing }
    }

    public func getWord(by uuid: UUID) -> Domain.Word? {
        return _wordList.first { $0.uuid == uuid }
    }

    public func updateWord(by uuid: UUID, to newWord: Domain.Word) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index] = newWord
        }
        _unmemorizedWordList.replaceWord(where: uuid, with: newWord)
    }

    public func randomizeUnmemorizedWordList() {
        _unmemorizedWordList.randomizeList(with: getUnmemorizedWordList())
    }

    public func updateToNextWord() {
        _unmemorizedWordList.updateToNextWord()
    }

    public func updateToPreviousWord() {
        _unmemorizedWordList.updateToPreviousWord()
    }

    public func markCurrentWordAsMemorized(uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index].memorizedState = .memorized
        }
        _unmemorizedWordList.deleteWord(by: uuid)
    }

    public func getCurrentUnmemorizedWord() -> Domain.Word? {
        return _unmemorizedWordList.getCurrentWord()
    }

}

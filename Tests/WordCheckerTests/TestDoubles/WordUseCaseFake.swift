//
//  WordUseCaseFake.swift
//  WordCheckerTests
//
//  Created by Jaewon Yun on 2023/09/12.
//

import Domain
import Foundation
import Utility

final class WordUseCaseFake: WordUseCaseProtocol {

    var _wordList: [Domain.Word] = []

    var _unmemorizedWordList: UnmemorizedWordListStateSpy = .init()

    func addNewWord(_ word: Domain.Word) {
        _wordList.append(word)
        _unmemorizedWordList.addWord(word)
    }

    func deleteWord(by uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList.remove(at: index)
        }
        _unmemorizedWordList.deleteWord(by: uuid)
    }

    func getWordList() -> [Domain.Word] {
        return _wordList
    }

    func getMemorizedWordList() -> [Domain.Word] {
        return _wordList.filter { $0.isMemorized == true }
    }

    func getUnmemorizedWordList() -> [Domain.Word] {
        return _wordList.filter { $0.isMemorized == false }
    }

    func getWord(by uuid: UUID) -> Domain.Word? {
        return _wordList.first { $0.uuid == uuid }
    }

    func updateWord(by uuid: UUID, to newWord: Domain.Word) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index] = newWord
        }
        _unmemorizedWordList.replaceWord(where: uuid, with: newWord)
    }

    func randomizeUnmemorizedWordList() {
        _unmemorizedWordList.randomizeList(with: _wordList)
    }

    func updateToNextWord() {
        _unmemorizedWordList.updateToNextWord()
    }

    func updateToPreviousWord() {
        _unmemorizedWordList.updateToPreviousWord()
    }

    func markCurrentWordAsMemorized(uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList[index].isMemorized = true
        }
        _unmemorizedWordList.deleteWord(by: uuid)
    }

}

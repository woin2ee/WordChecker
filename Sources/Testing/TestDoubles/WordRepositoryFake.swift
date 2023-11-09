//
//  WordRepositoryFake.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

public final class WordRepositoryFake: WordRepositoryProtocol {

    public var _wordList: [Word] = []

    public init(sampleData: [Word] = []) {
        _wordList = sampleData
    }

    public func get(by uuid: UUID) -> Domain.Word? {
        return _wordList.first(where: { $0.uuid == uuid })
    }

    public func save(_ word: Domain.Word) {
        if let index = _wordList.firstIndex(where: { $0.uuid == word.uuid }) {
            _wordList[index] = word
        } else {
            _wordList.append(word)
        }
    }

    public func getAll() -> [Domain.Word] {
        return _wordList
    }

    public func delete(by uuid: UUID) {
        if let index = _wordList.firstIndex(where: { $0.uuid == uuid }) {
            _wordList.remove(at: index)
        }
    }

    public func getUnmemorizedList() -> [Domain.Word] {
        return _wordList.filter { $0.memorizedState == .memorizing }
    }

    public func getMemorizedList() -> [Domain.Word] {
        return _wordList.filter { $0.memorizedState == .memorized }
    }

    public func reset(to wordList: [Domain.Word]) {
        _wordList = wordList
    }

}

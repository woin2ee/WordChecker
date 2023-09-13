//
//  WordRepositoryFake.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

public final class WordRepositoryFake: WordRepositoryProtocol {

    public var words: [Word] = []

    public init() {}

    public func get(by uuid: UUID) -> Domain.Word? {
        return words.first(where: { $0.uuid == uuid })
    }

    public func save(_ word: Domain.Word) {
        if let index = words.firstIndex(where: { $0.uuid == word.uuid }) {
            words[index] = word
        } else {
            words.append(word)
        }
    }

    public func getAll() -> [Domain.Word] {
        return words
    }

    public func delete(by uuid: UUID) {
        if let index = words.firstIndex(where: { $0.uuid == uuid }) {
            words.remove(at: index)
        }
    }

    public func getUnmemorizedList() -> [Domain.Word] {
        return words.filter { !$0.isMemorized }
    }

    public func getMemorizedList() -> [Domain.Word] {
        return words.filter { $0.isMemorized }
    }

}

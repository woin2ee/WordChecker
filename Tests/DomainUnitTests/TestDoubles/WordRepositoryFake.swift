//
//  WordRepositoryFake.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

final class WordRepositoryFake: WordRepositoryProtocol {

    var words: [Word] = []
    
    func get(by uuid: UUID) -> Domain.Word? {
        return words.first(where: { $0.uuid == uuid })
    }

    func save(_ word: Domain.Word) {
        if let index = words.firstIndex(where: { $0.uuid == word.uuid }) {
            words[index] = word
        } else {
            words.append(word)
        }
    }

    func getAll() -> [Domain.Word] {
        return words
    }

    func delete(_ word: Domain.Word) {
        if let index = words.firstIndex(where: { $0.uuid == word.uuid }) {
            words.remove(at: index)
        }
    }

    func getUnmemorizedList() -> [Domain.Word] {
        return words.filter { !$0.isMemorized }
    }

}

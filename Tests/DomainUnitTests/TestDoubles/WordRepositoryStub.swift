//
//  WordRepositoryStub.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

final class WordRepositoryStub: WordRepositoryProtocol {

    func get(by uuid: UUID) -> Domain.Word? {
        return .init(uuid: .init(), word: "A", isMemorized: true)
    }

    func save(_ word: Domain.Word) {

    }

    func getAll() -> [Domain.Word] {
        return [
            .init(uuid: .init(), word: "A", isMemorized: true),
            .init(uuid: .init(), word: "B", isMemorized: true),
            .init(uuid: .init(), word: "C", isMemorized: true),
            .init(uuid: .init(), word: "D", isMemorized: false),
            .init(uuid: .init(), word: "E", isMemorized: false)
        ]
    }

    func update(_ word: Domain.Word) {

    }

    func delete(_ word: Domain.Word) {

    }

    func getUnmemorizedList() -> [Domain.Word] {
        return [
            .init(uuid: .init(), word: "D", isMemorized: false),
            .init(uuid: .init(), word: "E", isMemorized: false)
        ]
    }

}

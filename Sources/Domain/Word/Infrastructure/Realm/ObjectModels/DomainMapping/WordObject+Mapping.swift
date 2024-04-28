//
//  Word+Mapping.swift
//  RealmPlatform
//
//  Created by Jaewon Yun on 2023/09/04.
//

extension Word {

    func toObjectModel() -> WordObject {
        let isMemorized: Bool

        switch self.memorizationState {
        case .memorized:
            isMemorized = true
        case .memorizing:
            isMemorized = false
        }

        return .init(uuid: self.uuid, word: self.word, isMemorized: isMemorized)
    }

}

extension WordObject {

    func toDomain() throws -> Word {
        let memorizationState: MemorizationState = self.isMemorized ? .memorized : .memorizing

        return try .init(uuid: self.uuid, word: self.word, memorizationState: memorizationState)
    }

}

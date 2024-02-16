//
//  Word+Mapping.swift
//  RealmPlatform
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Foundation

extension Domain.Word {

    func toObjectModel() -> Word {
        let isMemorized: Bool

        switch self.memorizedState {
        case .memorized:
            isMemorized = true
        case .memorizing:
            isMemorized = false
        }

        return .init(uuid: self.uuid, word: self.word, isMemorized: isMemorized)
    }

}

extension Word {

    func toDomain() throws -> Domain.Word {
        let memorizedState: MemorizedState = self.isMemorized ? .memorized : .memorizing

        return try .init(uuid: self.uuid, word: self.word, memorizedState: memorizedState)
    }

}

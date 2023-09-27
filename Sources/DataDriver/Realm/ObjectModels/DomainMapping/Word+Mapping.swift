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
        return .init(uuid: self.uuid, word: self.word, isMemorized: self.isMemorized)
    }

}

extension Word {

    func toDomain() -> Domain.Word {
        return .init(uuid: self.uuid, word: self.word, isMemorized: self.isMemorized)
    }

}

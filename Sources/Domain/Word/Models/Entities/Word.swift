//
//  Word.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain_Core
import Foundation
import FoundationPlus
import OSLog

public struct Word: Entity, Codable, Hashable {

    public var id: UUID { uuid }

    /// 엔티티를 구분하는데 사용되는 UUID
    public let uuid: UUID

    /// 문자열로 표현되는 단어
    public private(set) var word: String

    /// 암기 상태
    public var memorizationState: MemorizationState

    public init(uuid: UUID = .init(), word: String, memorizationState: MemorizationState = .memorizing) throws {
        guard word.hasElements else {
            let logger = Logger(subsystem: "Domain", category: "Entity")
            logger.error("Attempted to create a `Word` entity with an empty word.")
            throw EntityError.changeRejected(reason: .valueDisallowed)
        }

        self.uuid = uuid
        self.word = word
        self.memorizationState = memorizationState
    }

    private init() {
        self.uuid = .init()
        self.word = ""
        self.memorizationState = .memorizing
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.word = try container.decode(String.self, forKey: .word)
        
        do {
            self.memorizationState = try container.decode(MemorizationState.self, forKey: .memorizationState)
        } catch {
            // For compatibility of past coding key
            self.memorizationState = try container.decode(MemorizationState.self, forKey: .memorizedState)
        }
    }

    public mutating func setWord(_ word: String) throws {
        guard word.hasElements else {
            throw EntityError.changeRejected(reason: .valueDisallowed)
        }
        self.word = word
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(word, forKey: .word)
        try container.encode(memorizationState, forKey: .memorizationState)
    }
}

extension Word {

    public static var empty: Word {
        return .init()
    }

}

extension Word {
    enum CodingKeys: CodingKey {
        case uuid
        case word
        
        /// 암기 상태 (memorizationState와 같음)
        @available(*, deprecated, renamed: "memorizationState")
        case memorizedState
        /// 암기 상태 (memorizedState와 같음)
        case memorizationState
    }
}

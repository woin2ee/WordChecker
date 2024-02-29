//
//  Word.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation
import FoundationPlus

public final class Word: Codable {

    /// 엔티티를 구분하는데 사용되는 UUID
    public let uuid: UUID

    /// 문자열로 표현되는 단어
    public private(set) var word: String

    /// 암기 상태
    public var memorizedState: MemorizedState

    public init(uuid: UUID = .init(), word: String, memorizedState: MemorizedState = .memorizing) throws {
        guard word.hasElements else {
            DomainLogger(category: .entity).error("Attempted to create a `Word` entity with an empty word.")
            throw EntityError.changeRejected(reason: .valueDisallowed)
        }

        self.uuid = uuid
        self.word = word
        self.memorizedState = memorizedState
    }

    private init() {
        self.uuid = .init()
        self.word = ""
        self.memorizedState = .memorizing
    }

    public func setWord(_ word: String) throws {
        guard word.hasElements else {
            throw EntityError.changeRejected(reason: .valueDisallowed)
        }
        self.word = word
    }
}

extension Word: Hashable {

    public static func == (lhs: Word, rhs: Word) -> Bool {
        return (lhs.uuid == rhs.uuid) && (lhs.word == rhs.word) && (lhs.memorizedState == rhs.memorizedState)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(word)
        hasher.combine(memorizedState)
    }

}

extension Word {

    public static var empty: Word {
        return .init()
    }

}

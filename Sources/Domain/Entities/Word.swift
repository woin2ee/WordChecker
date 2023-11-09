//
//  Word.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public final class Word: Equatable, Hashable, Codable {

    public let uuid: UUID

    public var word: String

    public var memorizedState: MemorizedState

    public init(uuid: UUID = .init(), word: String, memorizedState: MemorizedState = .memorizing) {
        self.uuid = uuid
        self.word = word
        self.memorizedState = memorizedState
    }

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
        return .init(uuid: .init(), word: "", memorizedState: .memorizing)
    }

}

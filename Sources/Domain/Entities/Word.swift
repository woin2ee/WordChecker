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

    public var isMemorized: Bool

    public init(uuid: UUID = .init(), word: String, isMemorized: Bool = false) {
        self.uuid = uuid
        self.word = word
        self.isMemorized = isMemorized
    }

    public static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

}

extension Word {

    public static var empty: Word {
        return .init(uuid: .init(), word: "", isMemorized: false)
    }

}

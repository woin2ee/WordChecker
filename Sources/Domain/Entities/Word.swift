//
//  Word.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation

public final class Word: Equatable {

    public let uuid: UUID

    public var word: String

    public var isMemorized: Bool

    public init(uuid: UUID = .init(), word: String, isMemorized: Bool = false) {
        self.uuid = uuid
        self.word = word
        self.isMemorized = isMemorized
    }

    public static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.word == rhs.word && lhs.isMemorized == rhs.isMemorized
    }

}

//
//  WordAttribute.swift
//  Utility
//
//  Created by Jaewon Yun on 3/29/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

public struct WordAttribute {
    let word: String?
    let memorizationState: MemorizationState?

    public init(word: String? = nil, memorizationState: MemorizationState? = nil) {
        self.word = word
        self.memorizationState = memorizationState
    }
}

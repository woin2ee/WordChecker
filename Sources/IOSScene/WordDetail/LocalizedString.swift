//
//  LocalizedString.swift
//  WordAddition
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal struct LocalizedString {

    private init() {}

    static let word = NSLocalizedString("word", bundle: Bundle.module, comment: "")
    static let duplicate_word = NSLocalizedString("duplicate_word", bundle: Bundle.module, comment: "")
    static let done = NSLocalizedString("done", bundle: Bundle.module, comment: "")
    static let details = NSLocalizedString("details", bundle: Bundle.module, comment: "")
    static let memorizing = NSLocalizedString("memorizing", bundle: Bundle.module, comment: "")
    static let memorized = NSLocalizedString("memorized", bundle: Bundle.module, comment: "")
}

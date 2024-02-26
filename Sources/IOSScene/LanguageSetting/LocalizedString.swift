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

    static let source_language = NSLocalizedString("source_language", bundle: Bundle.module, comment: "")
    static let translation_language = NSLocalizedString("translation_language", bundle: Bundle.module, comment: "")
}

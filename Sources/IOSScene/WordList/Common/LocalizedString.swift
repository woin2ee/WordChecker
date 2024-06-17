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

    static let addWord = NSLocalizedString("addWord", bundle: Bundle.module, comment: "")
    static let all = NSLocalizedString("all", bundle: Bundle.module, comment: "")
    static let there_are_no_words = NSLocalizedString("there_are_no_words", bundle: Bundle.module, comment: "")
    static let memorizing = NSLocalizedString("memorizing", bundle: Bundle.module, comment: "")
    static let memorized = NSLocalizedString("memorized", bundle: Bundle.module, comment: "")
    static let delete = NSLocalizedString("delete", bundle: Bundle.module, comment: "")
    static let edit = NSLocalizedString("edit", bundle: Bundle.module, comment: "")
    static let editWord = NSLocalizedString("editWord", bundle: Bundle.module, comment: "")
    static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    static let edit_list = NSLocalizedString("edit_list", bundle: Bundle.module, comment: "")
}

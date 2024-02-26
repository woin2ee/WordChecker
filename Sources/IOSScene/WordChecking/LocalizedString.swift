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

    static let add = NSLocalizedString("add", bundle: Bundle.module, comment: "")
    static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    static let addWord = NSLocalizedString("addWord", bundle: Bundle.module, comment: "")
    static let more_menu = NSLocalizedString("more_menu", bundle: Bundle.module, comment: "")
    static let memorize_words = NSLocalizedString("memorize_words", bundle: Bundle.module, comment: "")
    static let memorized = NSLocalizedString("memorized", bundle: Bundle.module, comment: "")
    static let shuffleOrder = NSLocalizedString("shuffleOrder", bundle: Bundle.module, comment: "")
    static let deleteWord = NSLocalizedString("deleteWord", bundle: Bundle.module, comment: "")
    static let please_check_your_network_connection = NSLocalizedString("please_check_your_network_connection", bundle: Bundle.module, comment: "")
    static let noWords = NSLocalizedString("noWords", bundle: Bundle.module, comment: "")
    static let quick_add_word = NSLocalizedString("quick_add_word", bundle: Bundle.module, comment: "")
    static let translate = NSLocalizedString("translate", bundle: Bundle.module, comment: "")
    static let next_word = NSLocalizedString("next_word", bundle: Bundle.module, comment: "")
    static let previous_word = NSLocalizedString("previous_word", bundle: Bundle.module, comment: "")
    static let already_added_word = NSLocalizedString("already_added_word", bundle: Bundle.module, comment: "")
    static let notice = NSLocalizedString("notice", bundle: Bundle.module, comment: "")
    static let translation_site_alert_message = NSLocalizedString("translation_site_alert_message", bundle: Bundle.module, comment: "")

    static func word_added_failed(word: String) -> String {
        let localizedString = NSLocalizedString("%@_added_failed", bundle: Bundle.module, comment: "알 수 없는 이유로 단어 추가 실패 후 표시되는 메세지")
        return .init(format: localizedString, arguments: [word])
    }

    static func word_added_successfully(word: String) -> String {
        let localizedString = NSLocalizedString("%@_added_successfully", bundle: Bundle.module, comment: "단어 추가 완료 후 표시되는 메세지")
        return .init(format: localizedString, arguments: [word])
    }
}

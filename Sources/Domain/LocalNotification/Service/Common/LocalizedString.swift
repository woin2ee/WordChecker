//
//  LocalizedString.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

internal enum LocalizedString {

    static let daily_reminder = NSLocalizedString("daily_reminder", bundle: Bundle.module, comment: "")
    static func daily_reminder_body_message(unmemorizedWordCount: Int) -> String {
        let localizedString = NSLocalizedString("daily_reminder_body_message_%d", bundle: Bundle.module, comment: "")
        return .init(format: localizedString, arguments: [unmemorizedWordCount])
    }
    static let daily_reminder_body_message_when_no_words_to_memorize = NSLocalizedString("daily_reminder_body_message_when_no_words_to_memorize", bundle: Bundle.module, comment: "")

}

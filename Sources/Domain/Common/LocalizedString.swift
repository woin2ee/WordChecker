//
//  LocalizedString.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

enum LocalizedString {

    static let korean = NSLocalizedString("korean", bundle: Bundle.module, comment: "")
    static let english = NSLocalizedString("english", bundle: Bundle.module, comment: "")
    static let japanese = NSLocalizedString("japanese", bundle: Bundle.module, comment: "")
    static let chinese = NSLocalizedString("chinese", bundle: Bundle.module, comment: "")
    static let french = NSLocalizedString("french", bundle: Bundle.module, comment: "")
    static let spanish = NSLocalizedString("spanish", bundle: Bundle.module, comment: "")
    static let italian = NSLocalizedString("italian", bundle: Bundle.module, comment: "")
    static let german = NSLocalizedString("german", bundle: Bundle.module, comment: "")
    static let russian = NSLocalizedString("russian", bundle: Bundle.module, comment: "")

    static let daily_reminder = NSLocalizedString("daily_reminder", bundle: Bundle.module, comment: "")
    static func daily_reminder_body_message(unmemorizedWordCount: Int) -> String {
        let localizedString = NSLocalizedString("daily_reminder_body_message_%d", bundle: Bundle.module, comment: "")
        return .init(format: localizedString, arguments: [unmemorizedWordCount])
    }
    static let daily_reminder_body_message_when_no_words_to_memorize = NSLocalizedString("daily_reminder_body_message_when_no_words_to_memorize", bundle: Bundle.module, comment: "")

}

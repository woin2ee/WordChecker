//
//  LocalizedString.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal struct LocalizedString {

    private init() {}

    static let daily_reminder = NSLocalizedString("daily_reminder", bundle: Bundle.module, comment: "")
    static let notifications = NSLocalizedString("notifications", bundle: Bundle.module, comment: "")
    static let notice = NSLocalizedString("notice", bundle: Bundle.module, comment: "")
    static let time = NSLocalizedString("time", bundle: Bundle.module, comment: "")

    static let allow_notifications_is_required = NSLocalizedString("allow_notifications_is_required", bundle: Bundle.module, comment: "")
    static let dailyReminderFooter = NSLocalizedString("dailyReminderFooter", bundle: Bundle.module, comment: "")
}

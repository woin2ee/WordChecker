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

    static let source_language = NSLocalizedString("source_language", bundle: Bundle.module, comment: "")
    static let translation_language = NSLocalizedString("translation_language", bundle: Bundle.module, comment: "")
    static let notifications = NSLocalizedString("notifications", bundle: Bundle.module, comment: "")
    static let general = NSLocalizedString("general", bundle: Bundle.module, comment: "")
    static let settings = NSLocalizedString("settings", bundle: Bundle.module, comment: "")
    static let notice = NSLocalizedString("notice", bundle: Bundle.module, comment: "")

    static let google_drive_logout = NSLocalizedString("google_drive_logout", bundle: Bundle.module, comment: "")
    static let signed_out_of_google_drive_successfully = NSLocalizedString("signed_out_of_google_drive_successfully", bundle: Bundle.module, comment: "")

    static let google_drive_upload = NSLocalizedString("google_drive_upload", bundle: Bundle.module, comment: "")
    static let google_drive_upload_successfully = NSLocalizedString("google_drive_upload_successfully", bundle: Bundle.module, comment: "")

    static let google_drive_download = NSLocalizedString("google_drive_download", bundle: Bundle.module, comment: "")
    static let google_drive_download_successfully = NSLocalizedString("google_drive_download_successfully", bundle: Bundle.module, comment: "")
    
    static let haptics = NSLocalizedString("haptics", bundle: Bundle.module, comment: "")
    static let theme = NSLocalizedString("theme", bundle: Bundle.module, comment: "")
    static let system_mode = NSLocalizedString("system_mode", bundle: Bundle.module, comment: "")
    static let light_mode = NSLocalizedString("light_mode", bundle: Bundle.module, comment: "")
    static let dark_mode = NSLocalizedString("dark_mode", bundle: Bundle.module, comment: "")

    static let daily_reminder = NSLocalizedString("daily_reminder", bundle: Bundle.module, comment: "")
    static let time = NSLocalizedString("time", bundle: Bundle.module, comment: "")

    static let allow_notifications_is_required = NSLocalizedString("allow_notifications_is_required", bundle: Bundle.module, comment: "")
    static let dailyReminderFooter = NSLocalizedString("dailyReminderFooter", bundle: Bundle.module, comment: "")
    
    static let hapticsSettingsFooterTextWhenHapticsIsOn = NSLocalizedString("hapticsSettingsFooterTextWhenHapticsIsOn", bundle: Bundle.module, comment: "")
    static let hapticsSettingsFooterTextWhenHapticsIsOff = NSLocalizedString("hapticsSettingsFooterTextWhenHapticsIsOff", bundle: Bundle.module, comment: "")
}

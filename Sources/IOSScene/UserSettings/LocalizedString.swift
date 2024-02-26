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
}

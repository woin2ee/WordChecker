//
//  UserSettingsItemModel.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Localization

struct UserSettingsItemModel: Hashable, Sendable {

    let settingType: Settings

    var primaryText: String {
        switch settingType {
        case .changeSourceLanguage:
            WCString.source_language
        case .changeTargetLanguage:
            WCString.translation_language
        case .googleDriveUpload:
            WCString.google_drive_upload
        case .googleDriveDownload:
            WCString.google_drive_download
        }
    }

    var subtitle: String?

    var value: TranslationLanguage?

    init(settingType: Settings, subtitle: String? = nil, value: TranslationLanguage? = nil) {
        self.settingType = settingType
        self.subtitle = subtitle
        self.value = value
    }

}

extension UserSettingsItemModel {

    enum Settings: CaseIterable {

        case changeSourceLanguage
        case changeTargetLanguage

        case googleDriveUpload
        case googleDriveDownload

    }

}

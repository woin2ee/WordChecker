//
//  UserSettingsValueListModel.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Localization

struct UserSettingsValueListModel: Hashable, Sendable {

    let itemType: UserSettingsListType

    let value: TranslationLanguage

}

enum UserSettingsListType: CaseIterable {

    case sourceLanguageSetting

    case targetLanguageSetting

    var titleText: String {
        switch self {
        case .sourceLanguageSetting:
            WCString.source_language
        case .targetLanguageSetting:
            WCString.translation_language
        }
    }

}

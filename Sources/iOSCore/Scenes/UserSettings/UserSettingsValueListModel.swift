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

    let itemType: Style

    var primaryText: String {
        switch itemType {
        case .sourceLanguageSetting:
            WCString.source_language
        case .targetLanguageSetting:
            WCString.translation_language
        }
    }

    let value: TranslationLanguage

}

extension UserSettingsValueListModel {

    enum Style: CaseIterable {

        case sourceLanguageSetting

        case targetLanguageSetting

    }

}

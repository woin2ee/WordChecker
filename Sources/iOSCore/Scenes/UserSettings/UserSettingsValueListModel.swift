//
//  UserSettingsValueListModel.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation

struct UserSettingsValueListModel: Hashable, Sendable {

    let itemType: UserSettingsListType

    let value: TranslationLocale

}

enum UserSettingsListType: CaseIterable {

    case sourceLanguageSetting

    case targetLanguageSetting

}

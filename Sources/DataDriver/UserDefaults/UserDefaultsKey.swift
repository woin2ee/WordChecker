//
//  UserDefaultsKey.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import ExtendedUserDefaults

enum UserDefaultsKey: UserDefaultsKeyProtocol, CaseIterable {

    case translationSourceLocale

    case translationTargetLocale

    /// 테스트용 Key 입니다.
    case test

    var identifier: String {
        return String(describing: self)
    }

}

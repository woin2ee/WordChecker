//
//  UserDefaultsKey.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import ExtendedUserDefaults

internal enum UserDefaultsKey: UserDefaultsKeyProtocol, CaseIterable {

    case userSettings

    var identifier: String {
        return String(describing: self)
    }

}

//
//  WCUserDefaults.swift
//  Data
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

final class WCUserDefaults {

    private let _userDefaults: UserDefaults

    init(_userDefaults: UserDefaults) {
        self._userDefaults = _userDefaults
    }

    func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
        _userDefaults.setValue(value, forKey: key.rawValue)
    }

    func object(forKey key: UserDefaultsKey) -> Any? {
        return _userDefaults.object(forKey: key.rawValue)
    }

    enum UserDefaultsKey: String {

        case translationTargetLocale = "translationTargetLocale"

    }

}

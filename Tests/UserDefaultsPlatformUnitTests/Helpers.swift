//
//  Helpers.swift
//  UserDefaultsPlatformUnitTests
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import UserDefaultsPlatform
import Foundation

func clearWCUserDefaults(_ userDefaults: WCUserDefaults) {
    UserDefaultsKey.allCases.forEach { key in
        userDefaults.removeObject(forKey: key)
    }
}

//
//  UserSettingsSectionIdentifier.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/03.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

/// 화면에 섹션들이 실제 표시되는 순서대로 cases 가 선언되어 있습니다.
enum UserSettingsSectionIdentifier: Hashable, Sendable {
    case changeLanguage
    case notifications
    case googleDriveSync
    case signOut
}

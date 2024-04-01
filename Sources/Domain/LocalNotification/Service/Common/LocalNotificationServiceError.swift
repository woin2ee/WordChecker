//
//  LocalNotificationServiceError.swift
//  Service_ExternalStorage
//
//  Created by Jaewon Yun on 3/20/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal enum LocalNotificationServiceError: Error {

    /// 알림 허용이 되지 않았습니다.
    case notificationNotAuthorized

    /// 매일 알림이 저장된 적이 없습니다.
    case dailyReminderNeverSaved
}

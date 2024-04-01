//
//  DailyReminder.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

public struct DailyReminder {

    public static let identifier = "DailyReminder"

    public let unmemorizedWordCount: Int
    public let noticeTime: NoticeTime

    public init(unmemorizedWordCount: Int, noticeTime: NoticeTime) {
        self.unmemorizedWordCount = unmemorizedWordCount
        self.noticeTime = noticeTime
    }
}

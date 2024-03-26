//
//  NoticeTime.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/19/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

public struct NoticeTime: Codable {
    
    public let hour: Int
    public let minute: Int
    
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}

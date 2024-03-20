//
//  BackupFile.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/20/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public struct BackupFile {
    public let name: String
    public let data: Data
    
    public init(name: String, data: Data) {
        self.name = name
        self.data = data
    }
}

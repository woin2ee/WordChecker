//
//  BackupFile.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/20/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public struct BackupFile {
    public let name: BackupFileName
    public let data: Data

    public init(name: BackupFileName, data: Data) {
        self.name = name
        self.data = data
    }
}

/// 백업 파일 이름 목록
///
/// - Warning: 변경 시 기존 백업 파일이 유실될 수 있습니다.
public enum BackupFileName: String {
    case wordListBackup = "word_list_backup"
}

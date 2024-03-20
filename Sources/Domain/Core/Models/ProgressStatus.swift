//
//  ProgressStatus.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

/// 어떤 작업의 진행도를 표현할 때 사용하는 값.
public enum ProgressStatus {

    /// 진행중
    case inProgress

    /// 완료
    case complete

    /// 작업 없음
    case noTask

}

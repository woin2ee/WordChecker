//
//  MemorizedState.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/09.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

/// 암기 상태를 나타내는 값
public enum MemorizedState: Codable {

    /// 암기 완료 상태
    case memorized

    /// 암기 중 상태
    case memorizing

}

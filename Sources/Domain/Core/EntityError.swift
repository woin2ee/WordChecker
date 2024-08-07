//
//  EntityError.swift
//  Domain
//
//  Created by Jaewon Yun on 2/16/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public enum EntityError: Error {

    public enum ChangeRejectReason {

        /// 허용되지 않은 값입니다.
        case valueDisallowed
    }
    
    public enum CreateFailedReason {
        case containsInvalidValue
    }

    /// 엔티티 변경 거부됨
    case changeRejected(reason: ChangeRejectReason)
    
    /// 엔티티 생성 실패
    case createFailed(reason: CreateFailedReason)
}

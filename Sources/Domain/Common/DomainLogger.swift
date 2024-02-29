//
//  DomainLogger.swift
//  Domain
//
//  Created by Jaewon Yun on 2/29/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import OSLog

internal typealias DomainLogger = Logger

internal extension DomainLogger {
    
    enum Category: String {
        case entity
        case useCase
    }
    
    init(category: Category) {
        self.init(subsystem: "Domain", category: category.rawValue.capitalized)
    }
}

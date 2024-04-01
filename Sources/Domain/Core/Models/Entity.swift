//
//  Entity.swift
//  Domain_Core
//
//  Created by Jaewon Yun on 3/21/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

public protocol Entity {

    associatedtype Identifier: Sendable

    /// <#Description#>
    var id: Identifier { get }
}

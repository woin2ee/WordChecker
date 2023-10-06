//
//  Task+.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/06.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

extension Task where Success == Void, Failure == Never {

    @discardableResult
    public init(
        priority: TaskPriority? = nil,
        operation: @escaping (() async throws -> Void),
        catch: @escaping ((Error) -> Void)
    ) {
        self.init(priority: priority) {
            do {
                try await operation()
            } catch {
                `catch`(error)
            }
        }
    }

}

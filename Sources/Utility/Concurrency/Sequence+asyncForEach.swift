//
//  Sequence+asyncForEach.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/06.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

extension Sequence {

    public func asyncForEach(_ body: (Self.Element) async throws -> Void) async rethrows {
        for element in self {
            try await body(element)
        }
    }

}

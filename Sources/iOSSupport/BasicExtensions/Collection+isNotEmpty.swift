//
//  Collection+isNotEmpty.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/24.
//

import Foundation

extension Collection {

    /// A Boolean value indicating whether the collection is not empty.
    public var isNotEmpty: Bool {
        !isEmpty
    }
}

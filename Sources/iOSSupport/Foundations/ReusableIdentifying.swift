//
//  ReusableIdentifying.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 11/30/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

/// A protocol that provides a static variable `reuseIdentifier`.
public protocol ReusableIdentifying {

    /// A `reusableIdentifier` .
    ///
    /// If you don't override, it's concrete class name.
    static var reuseIdentifier: String { get }

}

// MARK: - Default implemetation

extension ReusableIdentifying {

    public static var reuseIdentifier: String {
        return .init(describing: Self.self)
    }

}

//
//  Utility.swift
//  Utility
//
//  Created by Jaewon Yun on 2023/09/07.
//

import Foundation

public func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }

    return result
}

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

public func unwrapOrThrow<T>(_ optionalValue: T?) throws -> T {
    guard let unwrappedValue = optionalValue else {
        throw UtilityError.nilValue(objectType: T.self)
    }
    return unwrappedValue
}

/// Swift does not implement abstract methods. This method is used as a runtime check to ensure that methods which intended to be abstract (i.e., they should be implemented in subclasses) are not called directly on the superclass.
public func abstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    fatalError(message, file: file, line: line)
}

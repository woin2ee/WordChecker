//
//  LaunchArgument.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation

public final class LaunchArgument {

    private init() {}

    /// 사용 가능한 launch argument 목록입니다.
    public enum Arguments: String {

        /// 인메모리 데이터베이스를 사용합니다.
        case useInMemoryDatabase = "-useInMemoryDatabase"

        /// 샘플 데이터를 적용합니다.
        case sampledDatabase = "-sampledDatabase"

        /// UserDefaults 를 초기화합니다.
        case initUserDefaults = "-initUserDefaults"

    }

    public static func contains(_ launchArguments: Arguments) -> Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains(launchArguments.rawValue)
    }

    public static func contains(_ launchArguments: String) -> Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains(launchArguments)
    }

    /// Launch arguments 가 올바르게 적용되었는지 검증합니다.
    public static func verify() {
        if self.contains(.useInMemoryDatabase) && self.contains(.sampledDatabase) {
            fatalError("\(Arguments.useInMemoryDatabase) and \(Arguments.sampledDatabase) should not be used together.")
        }
    }

}

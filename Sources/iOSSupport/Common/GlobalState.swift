//
//  GlobalState.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 1/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

/// 앱의 전역 상태를 가지는 객체입니다.
///
/// - Warning: 앱의 전역 상태를 나타내므로 반드시 Singleton 으로 사용해야 합니다.
public final class GlobalState {

    public static let shared: GlobalState = .init()

    private init() {}

    public var hapticsIsOn: Bool!

    /// 전역 상태를 초기화 합니다.
    public func initialize(hapticsIsOn: Bool) {
        self.hapticsIsOn = hapticsIsOn
    }

}

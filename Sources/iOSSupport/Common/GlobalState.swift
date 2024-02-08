//
//  GlobalState.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 1/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

/// 앱의 전역 상태를 가지는 객체입니다.
///
/// 전역 상태를 초기화하기 위해 `initialize()` 인스턴스 함수를 호출하는것이 권장됩니다.
///
/// - Note: 앱의 전역 상태를 나타내므로 공유 객체로 정의되어 있습니다.
public final class GlobalState {

    public static let shared: GlobalState = .init()

    /// 고정된 상태 값으로 객체를 초기화합니다.
    private init() {
        self.hapticsIsOn = true
        self.themeStyle = .init(value: .unspecified)
    }

    public var hapticsIsOn: Bool

    public var themeStyle: BehaviorRelay<UIUserInterfaceStyle>

    /// 전역 상태를 초기화합니다.
    ///
    /// 전달된 파라미터를 이용하여 전역 상태를 초기화합니다. 이 함수를 호출하여 초기화하지 않으면, 내부 생성자에서 고정된 값으로 전역 상태가 초기화됩니다.
    public func initialize(hapticsIsOn: Bool, themeStyle: UIUserInterfaceStyle) {
        self.hapticsIsOn = hapticsIsOn
        self.themeStyle = .init(value: themeStyle)
    }

}

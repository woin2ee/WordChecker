//
//  RxBaseViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

open class RxBaseViewController: BaseViewController {

    public var disposeBag: DisposeBag = .init()

    open override func viewDidLoad() {
        super.viewDidLoad()

        bindActions()
    }

    /// Rx 를 이용하여 UI Actions 를 바인딩합니다.
    ///
    /// 이 함수의 기본 구현은 아무것도 하지 않습니다.
    ///
    /// `viewDidLoad()` 에서 호출됩니다.
    open func bindActions() {}

}

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

        bindAction()
    }

    open func bindAction() {}

}

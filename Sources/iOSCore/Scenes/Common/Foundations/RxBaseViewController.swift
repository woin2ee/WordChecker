//
//  RxBaseViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public class RxBaseViewController: BaseViewController {

    public var disposeBag: DisposeBag = .init()

    public override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
    }

    func bindAction() {}

}

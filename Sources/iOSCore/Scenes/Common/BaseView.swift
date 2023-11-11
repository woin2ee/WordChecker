//
//  BaseView.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/11.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit
import Utility

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 이 함수에서 Subviews 를 설정하세요. `init(frame:)` 에서 호출됩니다.
    func setupSubviews() {
        abstractMethod()
    }

}

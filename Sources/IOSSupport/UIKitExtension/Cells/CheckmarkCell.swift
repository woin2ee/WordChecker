//
//  CheckmarkCell.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 2/5/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

public final class CheckmarkCell: RxBaseReusableCell {

    public struct Model: Hashable {
        public var title: String
        public var isChecked: Bool

        public init(title: String, isChecked: Bool) {
            self.title = title
            self.isChecked = isChecked
        }
    }

    public func bind(model: Model) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title

        self.contentConfiguration = config

        if model.isChecked {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
    }

}

//
//  TextFooterView.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit
import UIKitPlus

public final class TextFooterView: UITableViewHeaderFooterView, ReuseIdentifying {

    public var text: String = "" {
        didSet {
            var config = self.defaultContentConfiguration()
            config.text = text
            self.contentConfiguration = config
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

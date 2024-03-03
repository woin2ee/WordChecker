//
//  DisclosureIndicatorCell.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit
import UIKitPlus

public final class DisclosureIndicatorCell: UITableViewCell, ReuseIdentifying {

    public struct Model {
        let title: String
        let value: String?

        public init(title: String, value: String? = nil) {
            self.title = title
            self.value = value
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func bind(model: Model) {
        var config: UIListContentConfiguration = .valueCell()
        config.text = model.title
        config.secondaryText = model.value
        self.contentConfiguration = config
    }

}

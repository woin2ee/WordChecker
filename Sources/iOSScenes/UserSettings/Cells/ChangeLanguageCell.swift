//
//  ChangeLanguageCell.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import UIKit

final class ChangeLanguageCell: UITableViewCell, ReusableCell {

    struct CellModel {
        let title: String
        let value: String?
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(model: CellModel) {
        var config: UIListContentConfiguration = .valueCell()
        config.text = model.title
        config.secondaryText = model.value
        self.contentConfiguration = config
    }

}

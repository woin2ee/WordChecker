//
//  ButtonCell.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import UIKit

final class ButtonCell: UITableViewCell, ReusableCell {

    struct CellModel {
        let title: String
        let textColor: UIColor
    }

    func bind(model: CellModel) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title
        config.textProperties.color = model.textColor
        self.contentConfiguration = config
    }

}

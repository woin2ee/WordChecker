//
//  DatePickerCell.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 12/1/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import UIKit

final class DatePickerCell: RxBaseReusableCell {

    struct Model {
        let title: String
        let date: Date
    }

    let trailingDatePicker: UIDatePicker = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryView = trailingDatePicker
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(model: Model) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title
        self.contentConfiguration = config
        trailingDatePicker.setDate(model.date, animated: false)
    }

}

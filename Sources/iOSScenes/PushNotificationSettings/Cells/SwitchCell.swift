//
//  SwitchCell.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import RxSwift
import Then
import UIKit

final class SwitchCell: RxBaseReusableCell {

    struct Model {
        let title: String
        let isOn: Bool
    }

    let leadingLabel: UILabel = .init().then {
        $0.adjustsFontForContentSizeCategory = true
    }
    let trailingSwitch: UISwitch = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryView = trailingSwitch
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(model: Model) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title
        self.contentConfiguration = config
        trailingSwitch.setOn(model.isOn, animated: true)
    }

}

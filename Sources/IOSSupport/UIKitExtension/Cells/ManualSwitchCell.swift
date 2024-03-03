//
//  ManualSwitchCell.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit

public final class ManualSwitchCell: SwitchCell {

    public let wrappingButton: UIButton = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        trailingSwitch.addSubview(wrappingButton)
        wrappingButton.frame = trailingSwitch.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  PushNotificationSettingsView.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import Then
import UIKit
import UIKitPlus

final class PushNotificationSettingsView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.register(ManualSwitchCell.self)
        self.register(DatePickerCell.self)
        self.register(TextFooterView.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

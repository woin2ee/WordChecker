//
//  PushNotificationSettingsView.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import Then
import UIKit

final class PushNotificationSettingsView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.registerCell(ManualSwitchCell.self)
        self.registerCell(DatePickerCell.self)
        self.registerHeaderFooterView(TextFooterView.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

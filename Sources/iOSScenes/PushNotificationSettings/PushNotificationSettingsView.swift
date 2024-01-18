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

    let footerLabel: PaddingLabel = .init(padding: .init(top: 8, left: 20, bottom: 8, right: 20)).then {
        $0.text = WCString.dailyReminderFooter
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.register(ManualSwitchCell.self)
        self.register(DatePickerCell.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

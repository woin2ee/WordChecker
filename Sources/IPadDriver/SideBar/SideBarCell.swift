//
//  SideBarCell.swift
//  IPadDriver
//
//  Created by Jaewon Yun on 4/11/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Then
import UIKit
import UIKitPlus

internal final class SideBarCell: UITableViewCell {

    let overlayView = UIView().then {
        $0.backgroundColor = .systemGray
        $0.layer.opacity = 0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(overlayView)
        self.focusEffect = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.frame = self.bounds
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        // Set default state
        var contentConfig = (self.contentConfiguration as? UIListContentConfiguration)?.updated(for: state).with {
            $0.textProperties.color = .label
        }
        var backgroundConfig = self.backgroundConfiguration?.updated(for: state).with {
            $0.backgroundColor = .secondarySystemGroupedBackground
        }
        overlayView.layer.opacity = 0

        if state.isHighlighted {
            contentConfig?.textProperties.color = .label.withAlphaComponent(0.6)
            overlayView.layer.opacity = 0.2
        }

        if state.isSelected {
            backgroundConfig?.backgroundColor = .systemGray4
        }

        self.contentConfiguration = contentConfig
        self.backgroundConfiguration = backgroundConfig
    }
}

//
//  ManualSwitchCell.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import SnapKit
import UIKit

final class ManualSwitchCell: RxBaseReusableCell {

    struct Model {
        let title: String
        let isOn: Bool
    }

    let leadingLabel: UILabel = .init()
    let trailingSwitch: UISwitch = .init().then {
        $0.isUserInteractionEnabled = false
    }
    let wrappingButton: UIButton = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpSubviews() {
        self.contentView.addSubview(leadingLabel)
        self.contentView.addSubview(trailingSwitch)
        self.contentView.addSubview(wrappingButton)

        leadingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        trailingSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        wrappingButton.snp.makeConstraints { make in
            make.edges.equalTo(trailingSwitch).inset(-4)
        }
    }

    func bind(model: Model) {
        leadingLabel.text = model.title
        trailingSwitch.setOn(model.isOn, animated: true)
    }

}

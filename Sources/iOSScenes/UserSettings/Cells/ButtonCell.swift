//
//  ButtonCell.swift
//  UserSettings
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import UIKit

/// 버튼 역할을 하기 위한 Cell 클래스 입니다.
///
/// 버튼 가이드라인에 따른 텍스트 색상을 사용하세요.
final class ButtonCell: UITableViewCell, ReusableCell {

    struct Model {
        let title: String
        let textColor: UIColor
    }

    func bind(model: Model) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title
        config.textProperties.color = model.textColor
        self.contentConfiguration = config
    }

}

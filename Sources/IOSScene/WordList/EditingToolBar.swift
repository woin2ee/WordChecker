//
//  EditingToolBar.swift
//  IOSScene_WordList
//
//  Created by Jaewon Yun on 5/12/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import PinLayout
import RxCocoa
import RxSwift
import Then
import UIKit

final class EditingToolBar: UIToolbar {

    let markAsMemorizedButton = UIButton().then {
        $0.setTitle(String(localized: "Mark as Memorized", bundle: .module), for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    let deleteButton = UIButton().then {
        $0.setTitle(String(localized: "Delete", bundle: .module), for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemGray5
        self.addSubview(markAsMemorizedButton)
        self.addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpacing: CGFloat = 22
        markAsMemorizedButton.pin.vertically().start().width(50%).marginBottom(bottomSpacing)
        deleteButton.pin.vertically().end().after(of: markAsMemorizedButton).width(of: markAsMemorizedButton).marginBottom(bottomSpacing)
    }
}

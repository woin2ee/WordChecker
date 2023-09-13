//
//  WordChecking+ChangeWordButton.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import UIKit

extension WordCheckingViewController {

    final class ChangeWordButton: UIButton {

        let tappingColor: UIColor = .systemGray6.withAlphaComponent(0.6)

        init() {
            super.init(frame: .zero)

            self.tintColor = .clear
            self.backgroundColor = .clear
            self.setBackgroundColor(tappingColor, for: .highlighted)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            self.setBackgroundColor(tappingColor, for: .highlighted)
        }

    }

}

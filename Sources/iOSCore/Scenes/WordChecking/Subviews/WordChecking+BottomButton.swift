//
//  WordChecking+BottomButton.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import UIKit

extension WordCheckingView {

    final class BottomButton: UIButton {

        init(title: String, translatesAutoresizingMaskIntoConstraints: Bool = false) {
            super.init(frame: .zero)
            var attributedTitle: AttributedString = .init(stringLiteral: title)
            attributedTitle.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
            self.configuration = makeOwnConfig()
            self.configuration?.attributedTitle = attributedTitle
            self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func makeOwnConfig() -> UIButton.Configuration {
            var config: UIButton.Configuration = .filled()
            config.baseForegroundColor = .systemBackground
            config.baseBackgroundColor = .systemOrange
            config.buttonSize = .large
            return config
        }

    }

}

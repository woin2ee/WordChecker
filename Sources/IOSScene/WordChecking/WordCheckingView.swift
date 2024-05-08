//
//  WordCheckingView.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/11.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import IOSSupport
import RxSwift
import SnapKit
import Then
import UIKit

final class WordCheckingView: BaseView {

    let wordLabel: UILabel = .init().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.accessibilityIdentifier = AccessibilityIdentifier.wordLabel
    }

    lazy var previousButton: ChangeWordButton = .init().then {
        $0.accessibilityIdentifier = AccessibilityIdentifier.previousButton
        $0.accessibilityLabel = LocalizedString.previous_word
    }

    let previousButtonSymbol: ChangeWordSymbol = .init(direction: .left)

    lazy var nextButton: ChangeWordButton = .init().then {
        $0.accessibilityIdentifier = AccessibilityIdentifier.nextButton
        $0.accessibilityLabel = LocalizedString.next_word
    }

    let nextButtonSymbol: ChangeWordSymbol = .init(direction: .right)

    lazy var translateButton: BottomButton = .init(title: LocalizedString.translate)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.accessibilityElements = [
            previousButton,
            wordLabel,
            nextButton,
            translateButton,
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        self.addSubview(previousButton)
        self.addSubview(previousButtonSymbol)
        self.addSubview(nextButton)
        self.addSubview(nextButtonSymbol)
        self.addSubview(translateButton)
        self.addSubview(wordLabel)

        wordLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
            make.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(30)
        }

        previousButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.snp.centerX)
        }

        previousButtonSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(14)
        }

        nextButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.snp.centerX)
        }

        nextButtonSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(14)
        }

        translateButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
    }

    var fontSizeBinder: Binder<MemorizingWordSize> {
        return .init(wordLabel) { target, fontSize in
            target.font = fontSize.preferredFont
        }
    }
}

//
//  WordCheckingView.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/11.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Domain_WordManagement
import IOSSupport
import RxSwift
import SnapKit
import Then
import UIKit
import UIKitPlus

final class WordCheckingView: BaseView {

    let memorizingProgressBar: MemorizingProgressBar
    let wordLabel: UILabel
    let previousButton: ChangeWordButton
    let previousButtonSymbol: ChangeWordSymbol
    let nextButton: ChangeWordButton
    let nextButtonSymbol: ChangeWordSymbol
    let translateButton: BottomButton

    init() {
        memorizingProgressBar = MemorizingProgressBar().then {
            $0.backgroundColor = .systemGray3
            $0.progressBarColor = .systemBlue
        }
        wordLabel = UILabel().then {
            $0.adjustsFontForContentSizeCategory = true
            $0.numberOfLines = 0
        }
        previousButton = ChangeWordButton()
        previousButtonSymbol = ChangeWordSymbol(direction: .left)
        nextButton = ChangeWordButton()
        nextButtonSymbol = ChangeWordSymbol(direction: .right)
        translateButton = BottomButton(title: LocalizedString.translate)
        
        super.init(frame: .zero)

        // MARK: Accessibility settings
        
        wordLabel.accessibilityIdentifier = AccessibilityIdentifier.wordLabel
        
        previousButton.accessibilityIdentifier = AccessibilityIdentifier.previousButton
        previousButton.accessibilityLabel = LocalizedString.previous_word
        
        nextButton.accessibilityIdentifier = AccessibilityIdentifier.nextButton
        nextButton.accessibilityLabel = LocalizedString.next_word
        
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
        self.addSubview(memorizingProgressBar)

        memorizingProgressBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(26)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(26)
        }
        
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
    
    // MARK: Binders

    var fontSizeBinder: Binder<MemorizingWordSize> {
        return .init(wordLabel) { target, fontSize in
            target.font = fontSize.preferredFont
        }
    }
    
    var accessibilityLanguageBinder: Binder<(currentWord: Word?, translationSourceLanguage: TranslationLanguage)> {
        return .init(wordLabel) { target, element in
            if element.currentWord == nil {
                target.accessibilityLanguage = Locale.current.language.languageCode?.identifier
            } else {
                target.accessibilityLanguage = element.translationSourceLanguage.bcp47tag.rawValue
            }
        }
    }
    
    var memorizingCountAndIndexBinder: Binder<(memorizingCount: MemorizingCount, index: Int?)> {
        return .init(self) { (target: WordCheckingView, memorizingCountAndIndex) in
            let index = memorizingCountAndIndex.index
            let memorizingCount = memorizingCountAndIndex.memorizingCount
            
            if memorizingCount.total == 0 {
                target.previousButton.isEnabled = false
                target.previousButtonSymbol.tintColor = .systemGray
                target.nextButton.isEnabled = false
                target.nextButtonSymbol.tintColor = .systemGray
                return
            }
            
            if index == 0 {
                target.previousButton.isEnabled = false
                target.previousButtonSymbol.tintColor = .systemGray
            } else {
                target.previousButton.isEnabled = true
                target.previousButtonSymbol.tintColor = .systemBlue
            }
            
            if index == memorizingCount.total - 1 && memorizingCount.checked == memorizingCount.total {
                target.nextButton.isEnabled = false
                target.nextButtonSymbol.tintColor = .systemGray
            } else {
                target.nextButton.isEnabled = true
                target.nextButtonSymbol.tintColor = .systemBlue
            }
        }
    }
}

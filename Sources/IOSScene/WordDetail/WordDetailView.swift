//
//  WordDetailView.swift
//  IOSScene_WordDetail
//
//  Created by Jaewon Yun on 4/15/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_WordManagement
import IOSSupport
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class WordDetailView: UIView {

    let wordTextField: UITextField
    let duplicatedWordAlertLabel: UILabel
    private let memorizingButton: SelectableButton
    private let memorizedButton: SelectableButton
    
    var selectedMemorizationState: PublishRelay<MemorizationState> = .init()
    
    var memorizationStateBinder: Binder<MemorizationState> {
        return .init(self) { target, memorizationState in
            switch memorizationState {
            case .memorized:
                target.memorizedButton.isSelected = true
                target.memorizingButton.isSelected = false
            case .memorizing:
                target.memorizedButton.isSelected = false
                target.memorizingButton.isSelected = true
            }
        }
    }
    
    init() {
        self.wordTextField = UITextField().then {
            $0.placeholder = LocalizedString.word
            $0.borderStyle = .roundedRect
            $0.accessibilityIdentifier = AccessibilityIdentifier.wordTextField
        }
        
        self.duplicatedWordAlertLabel = UILabel().then {
            $0.text = LocalizedString.duplicate_word
            $0.textColor = .systemRed
            $0.adjustsFontForContentSizeCategory = true
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        do { // Initialize bottom buttons
            let titleAttributes = AttributeContainer([
                .font : UIFont.preferredFont(forTextStyle: .body, weight: .medium)
            ])
            
            self.memorizingButton = SelectableButton(
                backgroundColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray6,
                    selectedColor: .systemOrange.withAlphaComponent(0.4)
                ),
                strokeColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray6,
                    selectedColor: .systemOrange
                ),
                foregroundColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray,
                    selectedColor: .systemOrange
                )
            ).then {
                var config: UIButton.Configuration = .bordered()
                config.attributedTitle = AttributedString(
                    LocalizedString.memorizing,
                    attributes: titleAttributes
                )
                $0.configuration = config
                $0.accessibilityIdentifier = AccessibilityIdentifier.memorizingButton
            }
            
            self.memorizedButton = SelectableButton(
                backgroundColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray6,
                    selectedColor: .systemGreen.withAlphaComponent(0.4)
                ),
                strokeColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray6,
                    selectedColor: .systemGreen
                ),
                foregroundColorSet: SelectableButton.SelectionColorSet(
                    normalColor: .systemGray,
                    selectedColor: .systemGreen
                )
            ).then {
                var config: UIButton.Configuration = .bordered()
                config.attributedTitle = AttributedString(
                    LocalizedString.memorized,
                    attributes: titleAttributes
                )
                $0.configuration = config
                $0.accessibilityIdentifier = AccessibilityIdentifier.memorizedButton
            }
        }
        
        super.init(frame: .zero)
        
        self.memorizingButton.addAction(
            UIAction { [weak self] _ in
                self?.selectedMemorizationState.accept(.memorizing)
            },
            for: .touchUpInside
        )
        self.memorizedButton.addAction(
            UIAction { [weak self] _ in
                self?.selectedMemorizationState.accept(.memorized)
            },
            for: .touchUpInside
        )
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(wordTextField)
        self.addSubview(duplicatedWordAlertLabel)
        self.addSubview(memorizingButton)
        self.addSubview(memorizedButton)

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }

        duplicatedWordAlertLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(22)
            make.top.equalTo(wordTextField.snp.bottom).offset(10)
        }

        do { // Layout bottom buttons
            let spacing = 20
            let height = 60
            memorizingButton.snp.makeConstraints { make in
                make.top.equalTo(duplicatedWordAlertLabel.snp.bottom).offset(spacing)
                make.leading.equalTo(self.safeAreaLayoutGuide).inset(spacing)
                make.height.equalTo(height)
            }
            memorizedButton.snp.makeConstraints { make in
                make.top.equalTo(duplicatedWordAlertLabel.snp.bottom).offset(spacing)
                make.leading.equalTo(memorizingButton.snp.trailing).offset(spacing)
                make.trailing.equalTo(self.safeAreaLayoutGuide).inset(spacing)
                make.width.equalTo(memorizingButton)
                make.height.equalTo(height)
            }
        }
    }
}

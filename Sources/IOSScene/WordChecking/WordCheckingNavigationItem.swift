//
//  WordCheckingNavigationItem.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 4/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import RxCocoa
import RxSwift
import SFSafeSymbols
import Then
import UIKit

final class WordCheckingNavigationItem: UINavigationItem {
    
    typealias FontSize = MemorizingWordSize
    
    private let disposeBag = DisposeBag()
    
    private let addWordButton = UIBarButtonItem().then {
        $0.image = .init(systemSymbol: .plusApp)
        $0.accessibilityIdentifier = AccessibilityIdentifier.addWordButton
        $0.accessibilityLabel = LocalizedString.addWord
    }

    private let moreMenuButton = UIBarButtonItem().then {
        $0.image = .init(systemSymbol: .ellipsisCircle)
        $0.accessibilityIdentifier = AccessibilityIdentifier.moreButton
        $0.accessibilityLabel = LocalizedString.more_menu
    }
    
    private lazy var fontSizeGroup = UIMenu(
        title: LocalizedString.fontSize,
        image: UIImage(systemSymbol: .textformatSize),
        options: [.singleSelection],
        children: [
            smallFontSizeMenu,
            defaultFontSizeMenu,
            largeFontSizeMenu,
            veryLargeFontSizeMenu,
        ]
    )

    private lazy var smallFontSizeMenu = UIAction(
        title: LocalizedString.small,
        handler: { [weak self] _ in
            self?.selectedFontSize.accept(.small)
        }
    )
    
    private lazy var defaultFontSizeMenu = UIAction(
        title: LocalizedString.default,
        handler: { [weak self] _ in
            self?.selectedFontSize.accept(.default)
        }
    )
    
    private lazy var largeFontSizeMenu = UIAction(
        title: LocalizedString.large,
        handler: { [weak self] _ in
            self?.selectedFontSize.accept(.large)
        }
    )
    
    private lazy var veryLargeFontSizeMenu = UIAction(
        title: LocalizedString.veryLarge,
        handler: { [weak self] _ in
            self?.selectedFontSize.accept(.veryLarge)
        }
    )
    
    private lazy var basicGroup = UIDeferredMenuElement.uncached { [weak self] completion in
        guard let self = self else { return }
        
        let menu = UIMenu(
            options: .displayInline,
            children: [
                UIAction(
                    title: LocalizedString.memorized,
                    image: .init(systemSymbol: .checkmarkDiamondFill),
                    handler: { [weak self] _ in
                        self?.tapMemorizedMenu.accept(())
                    }
                ),
                UIAction(
                    title: LocalizedString.shuffleOrder,
                    image: .init(systemSymbol: .shuffle),
                    handler: { [weak self] _ in
                        self?.tapShuffleOrderMenu.accept(())
                    }
                ),
                fontSizeGroup
            ]
        )
        completion([menu])
    }
    
    private lazy var deleteMenu = UIAction(
        title: LocalizedString.deleteWord,
        image: .init(systemSymbol: .trash),
        attributes: .destructive,
        handler: { [weak self] _ in
            self?.tapDeleteWordMenu.accept(())
        }
    )
    
    var tapAddWordButton: ControlEvent<Void> { addWordButton.rx.tap }
    let tapMemorizedMenu = PublishRelay<Void>()
    let tapShuffleOrderMenu = PublishRelay<Void>()
    let tapDeleteWordMenu = PublishRelay<Void>()
    let selectedFontSize = PublishRelay<FontSize>()
    
    init() {
        super.init(title: "")
        
        self.titleView = UILabel.init().then {
            $0.text = LocalizedString.memorize_words
            $0.textColor = .clear
        }
        
        setUpRightBarButtonItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpRightBarButtonItems() {
        self.rightBarButtonItems = [moreMenuButton, addWordButton]
        moreMenuButton.menu = .init(children: [basicGroup, deleteMenu])
    }
    
    var fontSizeBinder: Binder<MemorizingWordSize> {
        return .init(self) { target, fontSize in
            switch fontSize {
            case .small:
                target.fontSizeGroup.subtitle = LocalizedString.small
                target.smallFontSizeMenu.state = .on
            case .default:
                target.fontSizeGroup.subtitle = LocalizedString.default
                target.defaultFontSizeMenu.state = .on
            case .large:
                target.fontSizeGroup.subtitle = LocalizedString.large
                target.largeFontSizeMenu.state = .on
            case .veryLarge:
                target.fontSizeGroup.subtitle = LocalizedString.veryLarge
                target.veryLargeFontSizeMenu.state = .on
            }
        }
    }
}

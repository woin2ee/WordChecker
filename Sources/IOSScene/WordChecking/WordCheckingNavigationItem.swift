//
//  WordCheckingNavigationItem.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 4/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import RxCocoa
import RxSwift
import SFSafeSymbols
import Then
import UIKit

final class WordCheckingNavigationItem: UINavigationItem {
    
    let addWordButton = UIBarButtonItem().then {
        $0.image = .init(systemSymbol: .plusApp)
        $0.accessibilityIdentifier = AccessibilityIdentifier.addWordButton
        $0.accessibilityLabel = LocalizedString.addWord
    }

    let moreMenuButton = UIBarButtonItem().then {
        $0.image = .init(systemSymbol: .ellipsisCircle)
        $0.accessibilityIdentifier = AccessibilityIdentifier.moreButton
        $0.accessibilityLabel = LocalizedString.more_menu
    }
    
    let tapMemorizedMenu = PublishRelay<Void>()
    let tapShuffleOrderMenu = PublishRelay<Void>()
    let tapDeleteWordMenu = PublishRelay<Void>()
    
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
        
        let menuGroup: UIMenu = .init(
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
            ]
        )
        let deleteMenu: UIAction = .init(
            title: LocalizedString.deleteWord,
            image: .init(systemSymbol: .trash),
            attributes: .destructive,
            handler: { [weak self] _ in
                self?.tapDeleteWordMenu.accept(())
            }
        )

        moreMenuButton.menu = .init(children: [menuGroup, deleteMenu])
    }
}

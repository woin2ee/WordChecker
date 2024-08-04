//
//  WordListNavigationItem.swift
//  IOSScene_WordList
//
//  Created by Jaewon Yun on 5/12/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import RxCocoa
import RxSwift
import SFSafeSymbols
import Then
import UIKit

final class WordListNavigationItem: UINavigationItem {
    
    let addWordButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init(systemItem: .add)
        button.accessibilityIdentifier = AccessibilityID.addWordButton
        button.style = .done
        button.accessibilityLabel = LocalizedString.addWord
        return button
    }()
    
    private lazy var settingsButton = UIBarButtonItem().then {
        $0.image = UIImage(systemSymbol: .gearshape)
        $0.accessibilityIdentifier = AccessibilityID.settingsButton
        $0.menu = UIMenu(children: [
            filterWordsGroup
        ])
    }
    
    let editButton = UIBarButtonItem(systemItem: .edit).then {
        $0.accessibilityLabel = LocalizedString.edit_list
    }
    let cancelButton = UIBarButtonItem(systemItem: .cancel)
    
    private lazy var filterWordsGroup = UIDeferredMenuElement.uncached { [weak self] completion in
        let menu = UIMenu(
            title: String(localized: "Showing", bundle: .module),
            options: [.displayInline, .singleSelection],
            children: [
                UIAction(
                    title: String(localized: "All", bundle: .module),
                    state: self?.selectedListType == .all ? .on : .off,
                    handler: { _ in
                        self?.didSelectSortType.accept(.all)
                    }
                ),
                UIAction(
                    title: String(localized: "Memorizing", bundle: .module),
                    state: self?.selectedListType == .memorizing ? .on : .off,
                    handler: { _ in
                        self?.didSelectSortType.accept(.memorizing)
                    }
                ),
                UIAction(
                    title: String(localized: "Memorized", bundle: .module),
                    state: self?.selectedListType == .memorized ? .on : .off,
                    handler: { _ in
                        self?.didSelectSortType.accept(.memorized)
                    }
                )
            ]
        )
        
        completion([menu])
    }
    
    let didSelectSortType = PublishRelay<WordListReactor.ListType>()
    private var selectedListType: WordListReactor.ListType = .all
    
    var listTypeBinder: Binder<WordListReactor.ListType> {
        Binder(self) { target, listType in
            switch listType {
            case .all:
                target.selectedListType = .all
            case .memorized:
                target.selectedListType = .memorized
            case .memorizing:
                target.selectedListType = .memorizing
            }
        }
    }
    
    var isEditingBinder: Binder<Bool> {
        Binder(self) { target, isEditing in
            if isEditing {
                target.setLeftBarButton(target.cancelButton, animated: true)
            } else {
                target.setLeftBarButton(target.editButton, animated: true)
            }
        }
    }
    
    init() {
        super.init(title: String(localized: "Words", bundle: .module))
        self.leftBarButtonItems = [editButton]
        self.rightBarButtonItems = [settingsButton, addWordButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachSearchBar(searchResultsController: (UIViewController & UISearchResultsUpdating)) {
        let searchController = UISearchController(searchResultsController: searchResultsController).then {
            $0.obscuresBackgroundDuringPresentation = true
            $0.searchResultsUpdater = searchResultsController
        }

        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = searchResultsController
        
        self.searchController = searchController
        self.hidesSearchBarWhenScrolling = false
    }
}

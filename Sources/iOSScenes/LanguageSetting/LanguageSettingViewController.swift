//
//  LanguageSettingViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/18.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import FoundationExtension
import iOSSupport
import OrderedCollections
import ReactorKit
import RxSwift
import Then
import UIKit

public protocol LanguageSettingViewControllerDelegate: AnyObject {

    /// ViewController 가 Pop 해야될때 호출되는 Delegate method 입니다.
    func viewMustPop()

}

public protocol LanguageSettingViewControllerProtocol: UIViewController {
    var delegate: LanguageSettingViewControllerDelegate? { get set }
}

public enum TranslationDirection {

    /// 원본 언어
    case sourceLanguage

    /// 번역 언어
    case targetLanguage

}

/// 원본/번역 언어 설정 화면
///
/// Resolve arguments:
/// - translationDirection: LanguageSetting.TranslationDirection
final class LanguageSettingViewController: RxBaseViewController, LanguageSettingViewControllerProtocol, View {

    enum SectionIdentifier: Int {
        case languages = 0
    }

    enum ItemIdentifier: Hashable {
        case language(TranslationLanguage)
    }

    /// `ItemIdentifier` 로 인해 구분되는 Item 들을 보여주기 위한 값을 가지고 있는 OrderedDictionary 타입 Model 입니다.
    ///
    /// `TableView` 에 보여지는 순서대로 값을 가지고 있습니다.
    lazy var itemModels: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model> = defaultItemModels

    /// 모든 Item 이 unchecked 인 `ItemModels`
    let defaultItemModels: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model> = TranslationLanguage.allCases
        .map { translationLanguage -> ItemIdentifier in
            return .language(translationLanguage)
        }
        .reduce(into: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model>()) { partialResult, itemIdentifier in
            if case let .language(translationLanguage) = itemIdentifier {
                partialResult[itemIdentifier] = .init(title: translationLanguage.localizedString, isChecked: false)
            }
        }

    lazy var dataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> = .init(tableView: languageSettingTableView) { [weak self] tableView, indexPath, itemIdentifier -> UITableViewCell? in
        guard let self = self else { return nil }
        guard let itemModel = itemModels[itemIdentifier] else {
            assertionFailure("\(itemIdentifier) 에 해당하는 itemModel 이 없습니다.")
            return nil
        }

        let cell = tableView.dequeueReusableCell(CheckmarkCell.self, for: indexPath)
        cell.bind(model: itemModel)
        return cell
    }

    weak var delegate: LanguageSettingViewControllerDelegate?

    lazy var languageSettingTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.registerCell(CheckmarkCell.self)
    }

    override func loadView() {
        self.view = languageSettingTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupNavigationBar()
        applyInitialSnapshotIfNoSections()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isMovingFromParent {
            delegate?.viewMustPop()
        }
    }

    /// 현재 Snapshot 에 추가된 Section 이 없다면 초기 snapshot 을 적용합니다.
    /// - Returns: 현재 Snapshot 에 추가된 Section 이 있다면 현재 snapshot 을 반환, 없다면 새로 적용한 snapshot 을 반환합니다.
    @discardableResult
    func applyInitialSnapshotIfNoSections() -> NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> {
        let currenetSnapshot = dataSource.snapshot()

        if currenetSnapshot.sectionIdentifiers.isNotEmpty {
            return currenetSnapshot
        }

        var snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> = .init()
        let itemIdentifiers = Array(itemModels.keys)

        snapshot.appendSections([.languages])
        snapshot.appendItems(itemIdentifiers, toSection: .languages)
        dataSource.applySnapshotUsingReloadData(snapshot)
        return snapshot
    }

    func bind(reactor: LanguageSettingReactor) {
        // Action
        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        languageSettingTableView.rx.itemSelected
            .doOnNext { [weak self] in self?.languageSettingTableView.deselectRow(at: $0, animated: true) }
            .map(Reactor.Action.selectCell)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.selectedCell)
            .skip(1) // skip initialState
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, selectedIndexPath in
                var snapshot = owner.dataSource.snapshot()
                snapshot = owner.applyInitialSnapshotIfNoSections()

                guard let sectionIdentifier = SectionIdentifier.init(rawValue: selectedIndexPath.section) else {
                    assertionFailure("Out of selectable cell.")
                    return
                }

                let selectedItemIdentifier = snapshot.itemIdentifiers(inSection: sectionIdentifier)[selectedIndexPath.row]

                if case .language = selectedItemIdentifier {
                    owner.itemModels = owner.defaultItemModels
                    var selectedItem = owner.itemModels[selectedItemIdentifier]
                    selectedItem?.isChecked = true
                    owner.itemModels[selectedItemIdentifier] = selectedItem
                }

                snapshot.reconfigureItems(snapshot.itemIdentifiers(inSection: sectionIdentifier))
                owner.dataSource.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
    }

    func setupNavigationBar() {
        guard let reactor = self.reactor else {
            preconditionFailure("Not assigned reactor of \(self).")
        }

        switch reactor.initialState.translationDirection {
        case .sourceLanguage:
            self.navigationItem.title = WCString.source_language
        case .targetLanguage:
            self.navigationItem.title = WCString.translation_language
        }

        self.navigationItem.largeTitleDisplayMode = .never
    }

}

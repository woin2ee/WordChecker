//
//  UserSettingsViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSSupport
import ReactorKit
import RxSwift
import RxUtility
import Then
import UIKit

public protocol UserSettingsViewControllerDelegate: AnyObject {

    func didTapSourceLanguageSettingRow(currentSettingLocale: TranslationLanguage)

    func didTapTargetLanguageSettingRow(currentSettingLocale: TranslationLanguage)

}

public final class UserSettingsViewController: RxBaseViewController, View {

    lazy var settingsTableViewDataSource: UITableViewDiffableDataSource<UserSettingsSection, UserSettingsItemModel> = .init(tableView: settingsTableView) { tableView, indexPath, item in
        switch item.settingType {
        case .changeSourceLanguage, .changeTargetLanguage:
            let cell = tableView.dequeueReusableCell(ChangeLanguageCell.self, for: indexPath)
            cell.bind(model: .init(title: item.primaryText, value: item.value?.localizedString))
            return cell
        case .googleDriveUpload, .googleDriveDownload:
            let cell = tableView.dequeueReusableCell(ButtonCell.self, for: indexPath)
            cell.bind(model: .init(title: item.primaryText, textColor: .systemBlue))
            return cell
        case .googleDriveSignOut:
            let cell = tableView.dequeueReusableCell(ButtonCell.self, for: indexPath)
            cell.bind(model: .init(title: item.primaryText, textColor: .systemRed))
            return cell
        }
    }

    public weak var delegate: UserSettingsViewControllerDelegate?

    lazy var settingsTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.register(ChangeLanguageCell.self, forCellReuseIdentifier: ChangeLanguageCell.reusableIdentifier)
        $0.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reusableIdentifier)
    }

    public override func loadView() {
        self.view = settingsTableView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        applyDefualtSnapshot()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    func applyDefualtSnapshot() {
        var snapshot: NSDiffableDataSourceSnapshot<UserSettingsSection, UserSettingsItemModel> = .init()

        snapshot.appendSections([.changeLanguage])
        snapshot.appendItems([
            .init(settingType: .changeSourceLanguage),
            .init(settingType: .changeTargetLanguage),
        ])

        snapshot.appendSections([.googleDriveSync])
        snapshot.appendItems([
            .init(settingType: .googleDriveUpload),
            .init(settingType: .googleDriveDownload),
        ])

        settingsTableViewDataSource.applySnapshotUsingReloadData(snapshot)
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.settings
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // swiftlint:disable:next function_body_length
    public func bind(reactor: UserSettingsReactor) {
        // Action
        let itemSelectedEvent = settingsTableView.rx.itemSelected.asSignal()
            .doOnNext { [weak self] in self?.settingsTableView.deselectRow(at: $0, animated: true) }

        let presentingWindow: PresentingConfiguration = .init(window: self)

        itemSelectedEvent
            .filter({ $0.section == 1 && $0.row == 0 })
            .map { _ in Reactor.Action.uploadData(presentingWindow) }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter({ $0.section == 1 && $0.row == 1 })
            .map { _ in Reactor.Action.downloadData(presentingWindow) }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter({ $0.section == 2 && $0.row == 0 })
            .map { _ in Reactor.Action.signOut }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter({ $0.section == 0 && $0.row == 0 })
            .emit(with: self, onNext: { owner, _ in
                owner.delegate?.didTapSourceLanguageSettingRow(currentSettingLocale: reactor.currentState.sourceLanguage)
            })
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter({ $0.section == 0 && $0.row == 1 })
            .emit(with: self, onNext: { owner, _ in
                owner.delegate?.didTapTargetLanguageSettingRow(currentSettingLocale: reactor.currentState.targetLanguage)
            })
            .disposed(by: self.disposeBag)

        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.hasSigned)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, hasSigned in
                var snapshot = owner.settingsTableViewDataSource.snapshot()
                snapshot.deleteSections([.signOut])

                if hasSigned {
                    snapshot.appendSections([.signOut])
                    snapshot.appendItems([.init(settingType: .googleDriveSignOut)])
                }

                owner.settingsTableViewDataSource.apply(snapshot)
            })
            .disposed(by: self.disposeBag)

        reactor.pulse(\.$showSignOutAlert)
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.signed_out_of_google_drive)
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.sourceLanguage)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, translationSourceLanguage in
                var snapshot = owner.settingsTableViewDataSource.snapshot()
                let originItems = snapshot.itemIdentifiers(inSection: .changeLanguage)

                guard let targetIndex = originItems.firstIndex(where: { $0.settingType == .changeSourceLanguage }) else {
                    assertionFailure("UserSettingsSection.changeLanguage 섹션에 SettingType.changeSourceLanguage 타입 item 이 없습니다.")
                    return
                }

                var newItems = originItems
                newItems[targetIndex].value = translationSourceLanguage

                snapshot.deleteItems(originItems)
                snapshot.appendItems(newItems, toSection: .changeLanguage)

                owner.settingsTableViewDataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.targetLanguage)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, translationTargetLanguage in
                var snapshot = owner.settingsTableViewDataSource.snapshot()
                let originItems = snapshot.itemIdentifiers(inSection: .changeLanguage)

                guard let targetIndex = originItems.firstIndex(where: { $0.settingType == .changeTargetLanguage }) else {
                    return
                }

                var newItems = originItems
                newItems[targetIndex].value = translationTargetLanguage

                snapshot.deleteItems(originItems)
                snapshot.appendItems(newItems, toSection: .changeLanguage)

                owner.settingsTableViewDataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.uploadStatus)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, status in
                switch status {
                case .noTask:
                    break
                case .inProgress:
                    ActivityIndicatorViewController.shared.startAnimating(on: self)
                case .complete:
                    ActivityIndicatorViewController.shared.stopAnimating(on: self)
                    owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_upload_successfully)
                }
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.downloadStatus)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, status in
                switch status {
                case .noTask:
                    break
                case .inProgress:
                    ActivityIndicatorViewController.shared.startAnimating(on: self)
                case .complete:
                    ActivityIndicatorViewController.shared.stopAnimating(on: self)
                    owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_download_successfully)
                }
            })
            .disposed(by: self.disposeBag)
    }

}

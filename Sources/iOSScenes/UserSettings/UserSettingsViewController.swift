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

    private(set) var dataSourceModel: [UserSettingsItemIdentifier: UserSettingsItem] = [
        .changeSourceLanguage: .changeLanguage(.init(title: WCString.source_language, value: nil)),
        .changeTargetLanguage: .changeLanguage(.init(title: WCString.translation_language, value: nil)),
        .googleDriveUpload: .button(.init(title: WCString.google_drive_upload, textColor: .systemBlue)),
        .googleDriveDownload: .button(.init(title: WCString.google_drive_download, textColor: .systemBlue)),
        .googleDriveSignOut: .button(.init(title: WCString.google_drive_logout, textColor: .systemRed)),
    ]

    lazy var settingsTableViewDataSource: UITableViewDiffableDataSource<UserSettingsSectionIdentifier, UserSettingsItemIdentifier> = .init(tableView: settingsTableView) { tableView, indexPath, id in
        guard let item = self.dataSourceModel[id] else {
            preconditionFailure("dataSourceModel 에 해당 \(id) 를 가진 Item 이 없습니다.")
        }

        switch item {
        case .changeLanguage(let model):
            let cell = tableView.dequeueReusableCell(ChangeLanguageCell.self, for: indexPath)
            cell.bind(model: model)
            return cell
        case .button(let model):
            let cell = tableView.dequeueReusableCell(ButtonCell.self, for: indexPath)
            cell.bind(model: model)
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
        var snapshot: NSDiffableDataSourceSnapshot<UserSettingsSectionIdentifier, UserSettingsItemIdentifier> = .init()
        snapshot.appendSections([.changeLanguage, .googleDriveSync])

        snapshot.appendItems(
            [.changeSourceLanguage, .changeTargetLanguage],
            toSection: .changeLanguage
        )

        snapshot.appendItems(
            [.googleDriveUpload, .googleDriveDownload],
            toSection: .googleDriveSync
        )

        settingsTableViewDataSource.apply(snapshot)
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.settings
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
    }

    // swiftlint:disable:next function_body_length
    public func bind(reactor: UserSettingsReactor) {
        // Action
        let itemSelectedEvent = settingsTableView.rx.itemSelected.asSignal()
            .doOnNext { [weak self] in self?.settingsTableView.deselectRow(at: $0, animated: true) }

        let presentingWindow: PresentingConfiguration = .init(window: self)

        itemSelectedEvent
            .filter { self.settingsTableViewDataSource.itemIdentifier(for: $0) == .googleDriveUpload }
            .map { _ in Reactor.Action.uploadData(presentingWindow) }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter { self.settingsTableViewDataSource.itemIdentifier(for: $0) == .googleDriveDownload }
            .map { _ in Reactor.Action.downloadData(presentingWindow) }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter { self.settingsTableViewDataSource.itemIdentifier(for: $0) == .googleDriveSignOut }
            .map { _ in Reactor.Action.signOut }
            .emit(to: reactor.action)
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter { self.settingsTableViewDataSource.itemIdentifier(for: $0) == .changeSourceLanguage }
            .emit(with: self, onNext: { owner, _ in
                owner.delegate?.didTapSourceLanguageSettingRow(currentSettingLocale: reactor.currentState.sourceLanguage)
            })
            .disposed(by: self.disposeBag)

        itemSelectedEvent
            .filter { self.settingsTableViewDataSource.itemIdentifier(for: $0) == .changeTargetLanguage }
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

                if hasSigned {
                    snapshot.insertSections([.signOut], afterSection: .googleDriveSync)
                    snapshot.appendItems(
                        [.googleDriveSignOut],
                        toSection: .signOut
                    )
                } else {
                    snapshot.deleteSections([.signOut])
                }

                owner.settingsTableViewDataSource.apply(snapshot)
            })
            .disposed(by: self.disposeBag)

        reactor.pulse(\.$showSignOutAlert)
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.signed_out_of_google_drive_successfully)
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.sourceLanguage)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, translationSourceLanguage in
                owner.dataSourceModel[.changeSourceLanguage] = .changeLanguage(.init(title: WCString.source_language, value: translationSourceLanguage.localizedString))

                var snapshot = owner.settingsTableViewDataSource.snapshot()
                snapshot.reconfigureItems([.changeSourceLanguage])
                owner.settingsTableViewDataSource.apply(snapshot)
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.targetLanguage)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, translationTargetLanguage in
                owner.dataSourceModel[.changeTargetLanguage] = .changeLanguage(.init(title: WCString.translation_language, value: translationTargetLanguage.localizedString))

                var snapshot = owner.settingsTableViewDataSource.snapshot()
                snapshot.reconfigureItems([.changeTargetLanguage])
                owner.settingsTableViewDataSource.apply(snapshot)
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

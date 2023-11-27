//
//  UserSettingsViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSSupport
import RxSwift
import RxUtility
import SnapKit
import Then
import UIKit

public protocol UserSettingsViewControllerDelegate: AnyObject {

    func didTapSourceLanguageSettingRow(currentSettingLocale: TranslationLanguage)

    func didTapTargetLanguageSettingRow(currentSettingLocale: TranslationLanguage)

}

public final class UserSettingsViewController: RxBaseViewController {

    var viewModel: UserSettingsViewModel!

    var settingsTableViewDataSource: UITableViewDiffableDataSource<UserSettingsSection, UserSettingsItemModel>!

    public weak var delegate: UserSettingsViewControllerDelegate?

    lazy var settingsTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(ChangeLanguageCell.self, forCellReuseIdentifier: ChangeLanguageCell.reusableIdentifier)
        $0.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reusableIdentifier)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        applyDefualtSnapshot()
        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    func setupDataSource() {
        self.settingsTableViewDataSource = .init(tableView: settingsTableView) { tableView, indexPath, item in
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

    // swiftlint:disable:next function_body_length
    func bindViewModel() {
        let itemSelectedEvent = settingsTableView.rx.itemSelected.asSignal()
            .doOnNext { [weak self] in self?.settingsTableView.deselectRow(at: $0, animated: true) }

        let input: UserSettingsViewModel.Input = .init(
            uploadTrigger: itemSelectedEvent
                .filter({ $0.section == 1 && $0.row == 0 })
                .mapToVoid(),
            downloadTrigger: itemSelectedEvent
                .filter({ $0.section == 1 && $0.row == 1 })
                .mapToVoid(),
            signOut: itemSelectedEvent
                .filter({ $0.section == 2 && $0.row == 0 })
                .mapToVoid(),
            presentingConfiguration: .just(.init(window: self))
        )
        let output = viewModel.transform(input: input)

        itemSelectedEvent
            .filter({ $0.section == 0 && $0.row == 0 })
            .mapToVoid()
            .withLatestFrom(output.currentTranslationSourceLanguage)
            .emit(with: self, onNext: { owner, translationSourceLanguage in
                owner.delegate?.didTapSourceLanguageSettingRow(currentSettingLocale: translationSourceLanguage)
            })
            .disposed(by: disposeBag)

        itemSelectedEvent
            .filter({ $0.section == 0 && $0.row == 1 })
            .mapToVoid()
            .withLatestFrom(output.currentTranslationTargetLanguage)
            .emit(with: self, onNext: { owner, translationTargetLanguage in
                owner.delegate?.didTapTargetLanguageSettingRow(currentSettingLocale: translationTargetLanguage)
            })
            .disposed(by: disposeBag)

        output.currentTranslationSourceLanguage
            .drive(with: self, onNext: { owner, translationSourceLanguage in
                var snapshot = owner.settingsTableViewDataSource.snapshot()
                let originItems = snapshot.itemIdentifiers(inSection: .changeLanguage)

                guard let targetIndex = originItems.firstIndex(where: { $0.settingType == .changeSourceLanguage }) else {
                    return
                }

                var newItems = originItems
                newItems[targetIndex].value = translationSourceLanguage

                snapshot.deleteItems(originItems)
                snapshot.appendItems(newItems, toSection: .changeLanguage)

                owner.settingsTableViewDataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)

        output.currentTranslationTargetLanguage
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
            .disposed(by: disposeBag)

        output.hasSigned
            .drive(with: self, onNext: { owner, hasSigned in
                var snapshot = owner.settingsTableViewDataSource.snapshot()
                snapshot.deleteSections([.signOut])

                if hasSigned {
                    snapshot.appendSections([.signOut])
                    snapshot.appendItems([
                        .init(settingType: .googleDriveSignOut)
                    ])
                }

                owner.settingsTableViewDataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        output.uploadStatus
            .emit(with: self, onNext: { owner, status in
                switch status {
                case .inProgress:
                    ActivityIndicatorViewController.shared.startAnimating(on: self)
                case .complete:
                    ActivityIndicatorViewController.shared.stopAnimating(on: self)
                    owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_upload_successfully)
                }
            })
            .disposed(by: disposeBag)

        output.downloadStatus
            .emit(with: self, onNext: { owner, status in
                switch status {
                case .inProgress:
                    ActivityIndicatorViewController.shared.startAnimating(on: self)
                case .complete:
                    ActivityIndicatorViewController.shared.stopAnimating(on: self)
                    owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_download_successfully)
                }
            })
            .disposed(by: disposeBag)

        output.signOut
            .emit(with: self, onNext: { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.signed_out_of_google_drive)
            })
            .disposed(by: disposeBag)
    }

    func setupSubviews() {
        self.view.addSubview(settingsTableView)

        settingsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.settings
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}

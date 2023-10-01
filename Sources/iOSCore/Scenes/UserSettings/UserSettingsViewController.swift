//
//  UserSettingsViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import RxSwift
import RxUtility
import SnapKit
import Then
import UIKit

final class UserSettingsViewController: BaseViewController {

    let disposeBag: DisposeBag = .init()

    let userSettingsCellID = "USER_SETTINGS_CELL"

    let viewModel: UserSettingsViewModel

    var settingsTableViewDataSource: UITableViewDiffableDataSource<UUID, UserSettingsItemModel>!

    lazy var settingsTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(UITableViewCell.self, forCellReuseIdentifier: userSettingsCellID)
    }

    init(viewModel: UserSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    func setupDataSource() {
        self.settingsTableViewDataSource = .init(tableView: settingsTableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.userSettingsCellID, for: indexPath)

            cell.accessoryType = .none

            var config: UIListContentConfiguration

            switch item.settingType {
            case .changeSourceLanguage, .changeTargetLanguage:
                config = .valueCell()
                config.secondaryText = item.value?.localizedString

                cell.accessoryType = .disclosureIndicator
            case .googleDriveUpload, .googleDriveDownload:
                config = .cell()
                config.textProperties.color = .systemBlue
            case .googleDriveLogout:
                config = .cell()
                config.textProperties.color = .systemRed
            }

            config.text = item.primaryText

            cell.contentConfiguration = config
            return cell
        }
    }

    func bindViewModel() {
        let input = UserSettingsViewModel.Input.init(
            selectItem: settingsTableView.rx.itemSelected
                .doOnNext { [weak self] in self?.settingsTableView.deselectRow(at: $0, animated: true) }
                .asSignalOnErrorJustComplete(),
            presentingConfiguration: .just(.init(window: self))
        )
        let output = viewModel.transform(input: input)

        output.userSettingsDataSource
            .drive(with: self) { owner, dataSource in
                var snapshot: NSDiffableDataSourceSnapshot<UUID, UserSettingsItemModel> = .init()

                dataSource.forEach { sectionModel in
                    snapshot.appendSections([UUID()])
                    snapshot.appendItems(sectionModel)
                }

                owner.settingsTableViewDataSource.applySnapshotUsingReloadData(snapshot)
            }
            .disposed(by: disposeBag)

        output.showLanguageSetting
            .emit(with: self, onNext: { owner, initData in
                let languageSettingVC: LanguageSettingViewController = DIContainer.shared.resolve(arguments: initData.settingsDirection, initData.currentSettingLocale)
                owner.navigationController?.pushViewController(languageSettingVC, animated: true)
            })
            .disposed(by: disposeBag)

        output.googleDriveUploadComplete
            .emit(with: self, onNext: { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_upload_successfully)
            })
            .disposed(by: disposeBag)

        output.googleDriveDownloadComplete
            .emit(with: self, onNext: { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.google_drive_download_successfully)
            })
            .disposed(by: disposeBag)

        output.googleDriveSignOutComplete
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

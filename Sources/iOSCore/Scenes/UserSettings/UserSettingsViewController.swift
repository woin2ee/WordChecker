//
//  UserSettingsViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Localization
import RxSwift
import RxUtility
import SnapKit
import Then
import UIKit

final class UserSettingsViewController: BaseViewController {

    let disposeBag: DisposeBag = .init()

    let userSettingsCellID = "USER_SETTINGS_CELL"

    let viewModel: UserSettingsViewModel

    var settingsTableViewDataSource: UITableViewDiffableDataSource<UUID, UserSettingsValueListModel>!

    lazy var settingsTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(UITableViewCell.self, forCellReuseIdentifier: userSettingsCellID)
    }

    init(viewModel: UserSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDataSource()
    }

    func setupDataSource() {
        self.settingsTableViewDataSource = .init(tableView: settingsTableView) { tableView, indexPath, item in
            var config = UIListContentConfiguration.valueCell()
            config.text =  item.itemType.titleText
            config.secondaryText = item.value.localizedString

            let cell = tableView.dequeueReusableCell(withIdentifier: self.userSettingsCellID, for: indexPath)
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
        bindViewModel()
        bindItemSelected()
    }

    func bindItemSelected() {
        settingsTableView.rx.itemSelected.asSignal()
            .emit(with: self, onNext: { owner, indexPath in
                let settingsDirection: LanguageSettingViewModel.SettingsDirection

                guard let model = owner.settingsTableViewDataSource.itemIdentifier(for: indexPath) else {
                    return
                }

                switch model.itemType {
                case .sourceLanguageSetting:
                    settingsDirection = .sourceLanguage
                case .targetLanguageSetting:
                    settingsDirection = .targetLanguage
                }

                let currentSettingLocale: TranslationLanguage = model.value

                let languageSettingVC: LanguageSettingViewController = DIContainer.shared.resolve(arguments: settingsDirection, currentSettingLocale)
                owner.navigationController?.pushViewController(languageSettingVC, animated: true)

                owner.settingsTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        let input = UserSettingsViewModel.Input.init()
        let output = viewModel.transform(input: input)

        output.userSettingsDataSource
            .drive(with: self) { owner, dataSource in
                var snapshot: NSDiffableDataSourceSnapshot<UUID, UserSettingsValueListModel> = .init()
                snapshot.appendSections([UUID()])
                snapshot.appendItems(dataSource)

                owner.settingsTableViewDataSource.applySnapshotUsingReloadData(snapshot)
            }
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

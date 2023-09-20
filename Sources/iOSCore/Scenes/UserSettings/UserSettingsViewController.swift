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

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    lazy var settingsTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: userSettingsCellID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()

        userSettingsUseCase.currentUserSettingsRelay
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.settingsTableView.reloadData()
            }
            .disposed(by: disposeBag)
    }

    init(userSettingsUseCase: UserSettingsUseCaseProtocol) {
        self.userSettingsUseCase = userSettingsUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension UserSettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var config = UIListContentConfiguration.valueCell()

        guard let currentUserSettings = userSettingsUseCase.currentUserSettingsRelay.value else {
            return .init()
        }

        if indexPath.row == 0 {
            config.text = WCString.source_language

            switch currentUserSettings.translationSourceLocale {
            case .korea:
                config.secondaryText = WCString.korean
            case .english:
                config.secondaryText = WCString.english
            }
        } else {
            config.text = WCString.translation_language

            switch currentUserSettings.translationTargetLocale {
            case .korea:
                config.secondaryText = WCString.korean
            case .english:
                config.secondaryText = WCString.english
            }
        }

        let cell: UITableViewCell = .init(style: .default, reuseIdentifier: userSettingsCellID)

        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

extension UserSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsDirection: LanguageSettingViewModel.SettingsDirection
        let currentSettingLocale: TranslationLocale

        guard let currentUserSettings = userSettingsUseCase.currentUserSettingsRelay.value else {
            return
        }

        if indexPath.row == 0 {
            settingsDirection = .sourceLanguage
            currentSettingLocale = currentUserSettings.translationSourceLocale
        } else {
            settingsDirection = .targetLanguage
            currentSettingLocale = currentUserSettings.translationTargetLocale
        }

        let languageSettingVC: LanguageSettingViewController = DIContainer.shared.resolve(arguments: settingsDirection, currentSettingLocale)
        self.navigationController?.pushViewController(languageSettingVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//
//  LanguageSettingViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/18.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Localization
import RxSwift
import SnapKit
import Then
import UIKit

final class LanguageSettingViewController: BaseViewController {

    let disposeBag: DisposeBag = .init()

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    let languageCellID = "LANGUAGE_SETTING_LANGUAGE_CELL"

    lazy var languageSettingTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: languageCellID)
    }

    init(userSettingsUseCase: UserSettingsUseCaseProtocol) {
        self.userSettingsUseCase = userSettingsUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
    }

    func setupSubviews() {
        self.view.addSubview(languageSettingTableView)

        languageSettingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.languages
        self.navigationItem.largeTitleDisplayMode = .never
    }

}

extension LanguageSettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TranslationTargetLocale.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var config = UIListContentConfiguration.cell()

        switch TranslationTargetLocale.allCases[indexPath.row] {
        case .korea:
            config.text = WCString.korean
        case .english:
            config.text = WCString.english
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: languageCellID, for: indexPath)
        cell.contentConfiguration = config

        return cell
    }

}

extension LanguageSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocale = TranslationTargetLocale.allCases[indexPath.row]

        userSettingsUseCase.setTranslationLocale(to: selectedLocale)
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}

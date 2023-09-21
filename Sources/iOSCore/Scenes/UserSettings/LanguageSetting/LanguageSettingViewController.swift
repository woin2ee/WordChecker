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

    let viewModel: LanguageSettingViewModel

    let languageCellID = "LANGUAGE_SETTING_LANGUAGE_CELL"

    lazy var languageSettingTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(UITableViewCell.self, forCellReuseIdentifier: languageCellID)
    }

    init(viewModel: LanguageSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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

    func bindViewModel() {
        let input = LanguageSettingViewModel.Input.init(selectCell: languageSettingTableView.rx.itemSelected.asSignal())
        let output = viewModel.transform(input: input)

        output.selectableLocales
            .drive(languageSettingTableView.rx.items) { tableView, row, locale -> UITableViewCell in
                var config = UIListContentConfiguration.cell()
                config.text = locale.localizedString

                let cell = tableView.dequeueReusableCell(withIdentifier: self.languageCellID, for: .init(row: row, section: 0))
                cell.contentConfiguration = config

                if locale == self.viewModel.currentSettingLocale {
                    cell.accessoryType = .checkmark
                }

                return cell
            }
            .disposed(by: disposeBag)

        output.didSelectCell
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
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

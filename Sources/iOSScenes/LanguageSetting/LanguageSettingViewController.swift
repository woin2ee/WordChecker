//
//  LanguageSettingViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/18.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSSupport
import RxSwift
import SnapKit
import Then
import UIKit

public protocol LanguageSettingViewControllerDelegate: AnyObject {

    func didSelectLanguageRow()

}

public protocol LanguageSettingViewControllerProtocol: UIViewController {
    var delegate: LanguageSettingViewControllerDelegate? { get set }
}

/// 원본/번역 언어 설정 화면
///
/// Resolve arguments:
/// - settingsDirection: LanguageSettingViewModel.SettingsDirection
/// - currentSettingLocale: TranslationLanguage)
final class LanguageSettingViewController: RxBaseViewController, LanguageSettingViewControllerProtocol {

    var viewModel: LanguageSettingViewModel!

    let languageCellID = "LANGUAGE_SETTING_LANGUAGE_CELL"

    weak var delegate: LanguageSettingViewControllerDelegate?

    lazy var languageSettingTableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .systemGroupedBackground
        $0.register(UITableViewCell.self, forCellReuseIdentifier: languageCellID)
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
            .drive(languageSettingTableView.rx.items) { [weak self] tableView, row, locale -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }

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
                owner.delegate?.didSelectLanguageRow()
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
        switch viewModel.settingsDirection {
        case .sourceLanguage:
            self.navigationItem.title = WCString.source_language
        case .targetLanguage:
            self.navigationItem.title = WCString.translation_language
        }

        self.navigationItem.largeTitleDisplayMode = .never
    }

}

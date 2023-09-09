//
//  WordDetailViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Combine
import Domain
import SnapKit
import UIKit
import Utility

final class WordDetailViewController: UIViewController {

    let viewModel: WordDetailViewModelProtocol

    var cancelBag: Set<AnyCancellable> = .init()

    let wordTextField: UITextField = {
        let textField: UITextField = .init()
        textField.placeholder = WCString.word
        textField.borderStyle = .roundedRect
        textField.accessibilityIdentifier = AccessibilityIdentifier.WordDetail.wordTextField
        return textField
    }()

    let memorizedLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "단어 암기 상태"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    lazy var memorizationStatePopupButton: UIButton = {
        var config: UIButton.Configuration = .bordered()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .label
        let button: UIButton = .init(configuration: config)
        button.menu = .init(children: [
            UIAction.init(title: WCString.memorizing) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(WCString.memorizing, for: .normal)
            },
            UIAction.init(title: WCString.memorized) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(WCString.memorized, for: .normal)
            }
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.accessibilityIdentifier = AccessibilityIdentifier.WordDetail.memorizationStateButton
        return button
    }()

    init(viewModel: WordDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    private func setupSubviews() {
        self.view.addSubview(wordTextField)
        self.view.addSubview(memorizedLabel)
        self.view.addSubview(memorizationStatePopupButton)

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        memorizationStatePopupButton.snp.makeConstraints { make in
            make.top.equalTo(wordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func setupNavigationBar() {
        let doneAction: UIAction = .init { [weak self] _ in
            guard let self = self else { return }
            let memorizedMenu: UIAction = castOrFatalError(self.memorizationStatePopupButton.menu?.children[1])
            let isMemorized = (memorizedMenu.state == .on)
            let word: Word = .init(
                word: self.wordTextField.text ?? "",
                isMemorized: isMemorized
            )
            self.viewModel.doneEditing(word)
            self.dismiss(animated: true)
        }
        let doneBarButton: UIBarButtonItem = .init(title: WCString.done, primaryAction: doneAction)
        doneBarButton.style = .done

        let cancelAction: UIAction = .init { [weak self] _ in
            self?.dismiss(animated: true)
        }
        let cancelButton: UIBarButtonItem = .init(systemItem: .cancel, primaryAction: cancelAction)

        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.leftBarButtonItem = cancelButton

        self.navigationItem.title = WCString.details
    }

    func bindViewModel() {
        viewModel.word
            .sink { [weak self] word in
                guard let self = self else { return }
                self.wordTextField.text = word.word
                if word.isMemorized {
                    (self.memorizationStatePopupButton.menu?.children[1] as? UIAction)?.state = .on
                    self.memorizationStatePopupButton.setTitle(WCString.memorized, for: .normal)
                } else {
                    (self.memorizationStatePopupButton.menu?.children[0] as? UIAction)?.state = .on
                    self.memorizationStatePopupButton.setTitle(WCString.memorizing, for: .normal)
                }
            }
            .store(in: &cancelBag)
    }

}

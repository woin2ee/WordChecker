//
//  WordDetailViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Combine
import UIKit

final class WordDetailViewController: UIViewController {

    let viewModel: WordDetailViewModelProtocol

    var cancelBag: Set<AnyCancellable> = .init()

    let wordTextField: UITextField = {
        let textField: UITextField = .init()
        textField.placeholder = WCString.word
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let memorizedLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "단어 암기 완료"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    let memorizedSwitch: UISwitch = {
        let memorizedSwitch: UISwitch = .init()
        memorizedSwitch.isOn = true
        memorizedSwitch.translatesAutoresizingMaskIntoConstraints = false
        return memorizedSwitch
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
        self.view.addSubview(memorizedSwitch)

        NSLayoutConstraint.activate([
            wordTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            wordTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0),
            wordTextField.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: 1.0)
        ])

        NSLayoutConstraint.activate([
            memorizedSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            memorizedSwitch.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    private func setupNavigationBar() {
        let doneAction: UIAction = .init { [weak self] _ in
            self?.viewModel.doneEditing()
        }
        let doneBarButton: UIBarButtonItem = .init(title: WCString.done, primaryAction: doneAction)
        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.title = WCString.details
    }

    func bindViewModel() {

    }

}

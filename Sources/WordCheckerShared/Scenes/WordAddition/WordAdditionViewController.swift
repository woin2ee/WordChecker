//
//  WordAdditionViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import SnapKit
import UIKit

final class WordAdditionViewController: BaseViewController {

    let viewModel: WordAdditionViewModel

    let wordTextField: UITextField = {
        let textField: UITextField = .init()
        textField.placeholder = WCString.word
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var cancelBarButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init(systemItem: .cancel)
        button.primaryAction = .init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        return button

    }()

    lazy var doneBarButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init(systemItem: .done)
        button.style = .done
        button.primaryAction = .init(handler: { [weak self] _ in
            let currentWord = self?.wordTextField.text ?? ""
            let word: Word = .init(word: currentWord)
            self?.viewModel.finishAddingWord(word)
            self?.dismiss(animated: true)
        })
        return button
    }()

    init(viewModel: WordAdditionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTextFieldObserver()
        setupNavigationBar()
        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateDoneButtonEnableState()
    }

    func setupSubviews() {
        self.view.addSubview(wordTextField)

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }

    func addTextFieldObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDoneButtonEnableState),
            name: UITextField.textDidChangeNotification,
            object: wordTextField
        )
    }

    @objc func updateDoneButtonEnableState() {
        doneBarButton.isEnabled = !(wordTextField.text ?? "").isEmpty
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.newWord

        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = doneBarButton
    }

}

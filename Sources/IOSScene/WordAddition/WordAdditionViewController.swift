//
//  WordAdditionViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import IOSSupport
import RxSwift
import RxCocoa
import RxSwiftSugar
import SnapKit
import Then
import UIKit

public protocol WordAdditionViewControllerDelegate: AnyObject, ViewControllerDelegate {
}

public protocol WordAdditionViewControllerProtocol: UIViewController {
    var delegate: WordAdditionViewControllerDelegate? { get set }
}

final class WordAdditionViewController: RxBaseViewController, WordAdditionViewControllerProtocol {

    var viewModel: WordAdditionViewModel!

    weak var delegate: WordAdditionViewControllerDelegate?

    let wordTextField: UITextField = .init().then {
        $0.placeholder = LocalizedString.word
        $0.borderStyle = .roundedRect
    }

    let duplicatedWordAlertLabel: UILabel = .init().then {
        $0.text = LocalizedString.duplicate_word
        $0.textColor = .systemRed
        $0.adjustsFontForContentSizeCategory = true
        $0.font = .preferredFont(forTextStyle: .footnote)
    }

    lazy var cancelBarButton: UIBarButtonItem = .init(systemItem: .cancel)

    lazy var doneBarButton: UIBarButtonItem = .init(systemItem: .done).then {
        $0.style = .done
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true

        setupNavigationBar()
        setupSubviews()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        wordTextField.becomeFirstResponder()
    }

    func setupSubviews() {
        self.view.addSubview(wordTextField)
        self.view.addSubview(duplicatedWordAlertLabel)

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        duplicatedWordAlertLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(22)
            make.top.equalTo(wordTextField.snp.bottom).offset(10)
        }
    }

    func setupNavigationBar() {
        self.navigationItem.title = LocalizedString.newWord

        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = doneBarButton
    }

    func bindViewModel() {
        guard let presentationController = self.navigationController?.presentationController else {
            assertionFailure("The presentation controller is not set.")
            return
        }
        let input: WordAdditionViewModel.Input = .init(
            wordText: wordTextField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
            saveAttempt: doneBarButton.rx.tap.asSignal(),
            dismissAttempt: Signal.merge(
                cancelBarButton.rx.tap.asSignal(),
                presentationController.rx.didAttemptToDismiss.asSignalOnErrorJustComplete()
            )
        )
        let output = viewModel.transform(input: input)

        [
            output.saveComplete
                .emit(with: self, onNext: { owner, _ in
                    owner.delegate?.viewControllerMustBeDismissed(owner)
                }),
            output.reconfirmDismiss
                .emit(with: self, onNext: { owner, _ in
                    owner.presentDismissActionSheet {
                        owner.delegate?.viewControllerMustBeDismissed(owner)
                    }
                }),
            output.dismissComplete
                .emit(with: self, onNext: { owner, _ in
                    owner.delegate?.viewControllerMustBeDismissed(owner)
                }),
            output.enteredWordIsDuplicated
                .distinctUntilChanged()
                .map { !$0 }
                .drive(duplicatedWordAlertLabel.rx.isHidden),
            Driver.zip([
                output.wordTextIsNotEmpty,
                output.enteredWordIsDuplicated,
            ]).map { $0[0] && !$0[1] }
                .drive(doneBarButton.rx.isEnabled),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }

}

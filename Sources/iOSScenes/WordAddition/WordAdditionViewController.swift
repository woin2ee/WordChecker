//
//  WordAdditionViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import iOSSupport
import RxSwift
import RxCocoa
import RxUtility
import SnapKit
import Then
import UIKit

public protocol WordAdditionViewControllerDelegate: AnyObject {

    func didFinishInteration()

}

public protocol WordAdditionViewControllerProtocol: UIViewController {
    var delegate: WordAdditionViewControllerDelegate? { get set }
}

final class WordAdditionViewController: RxBaseViewController, WordAdditionViewControllerProtocol {

    var viewModel: WordAdditionViewModel!

    weak var delegate: WordAdditionViewControllerDelegate?

    let wordTextField: UITextField = .init().then {
        $0.placeholder = WCString.word
        $0.borderStyle = .roundedRect
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

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.newWord

        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = doneBarButton
    }

    func bindViewModel() {
        guard let presentationController = self.navigationController?.presentationController else {
            assertionFailure("The presentation controller is not set.")
            return
        }
        let input: WordAdditionViewModel.Input = .init(
            wordText: wordTextField.rx.text.orEmpty.asDriver(),
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
                    owner.delegate?.didFinishInteration()
                }),
            output.wordTextIsNotEmpty
                .drive(doneBarButton.rx.isEnabled),
            output.reconfirmDismiss
                .emit(with: self, onNext: { owner, _ in
                    owner.presentDismissActionSheet {
                        owner.delegate?.didFinishInteration()
                    }
                }),
            output.dismissComplete
                .emit(with: self, onNext: { owner, _ in
                    owner.delegate?.didFinishInteration()
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }

}

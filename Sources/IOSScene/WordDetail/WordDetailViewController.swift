//
//  WordDetailViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import IOSSupport
import ReactorKit
import RxCocoa
import SnapKit
import Then
import UIKit
import Utility

public protocol WordDetailViewControllerDelegate: AnyObject, ViewControllerDelegate {
}

public protocol WordDetailViewControllerProtocol: UIViewController {
    var delegate: WordDetailViewControllerDelegate? { get set }
}

/// 상세 보기 화면
///
/// Resolve arguments: (uuid: UUID)
final class WordDetailViewController: RxBaseViewController, WordDetailViewControllerProtocol {

    weak var delegate: WordDetailViewControllerDelegate?

    // MARK: - UI Objects Declaration

    let wordTextField: UITextField = .init().then {
        $0.placeholder = LocalizedString.word
        $0.borderStyle = .roundedRect
        $0.accessibilityIdentifier = AccessibilityIdentifier.wordTextField
    }

    let duplicatedWordAlertLabel: UILabel = .init().then {
        $0.text = LocalizedString.duplicate_word
        $0.textColor = .systemRed
        $0.adjustsFontForContentSizeCategory = true
        $0.font = .preferredFont(forTextStyle: .footnote)
    }

    lazy var memorizationStatePopupButton: UIButton = {
        var config: UIButton.Configuration = .bordered()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .label

        let button: UIButton = .init(configuration: config)

        button.menu = .init(children: [
            UIAction.init(title: LocalizedString.memorizing) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(LocalizedString.memorizing, for: .normal)
                self?.reactor?.action.onNext(.changeMemorizedState(.memorizing))
            },
            UIAction.init(title: LocalizedString.memorized) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(LocalizedString.memorized, for: .normal)
                self?.reactor?.action.onNext(.changeMemorizedState(.memorized))
            },
        ])

        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.accessibilityIdentifier = AccessibilityIdentifier.memorizationStateButton

        return button
    }()

    let doneBarButton: UIBarButtonItem = .init(title: LocalizedString.done).then {
        $0.style = .done
    }

    let cancelBarButton: UIBarButtonItem = .init(systemItem: .cancel)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.presentationController?.delegate = self

        setupSubviews()
        setupNavigationBar()
    }

    private func setupSubviews() {
        self.view.addSubview(wordTextField)
        self.view.addSubview(duplicatedWordAlertLabel)
        self.view.addSubview(memorizationStatePopupButton)

        wordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        duplicatedWordAlertLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(22)
            make.top.equalTo(wordTextField.snp.bottom).offset(10)
        }

        memorizationStatePopupButton.snp.makeConstraints { make in
            make.top.equalTo(duplicatedWordAlertLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func setupNavigationBar() {
        self.navigationItem.title = LocalizedString.details

        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }

    override func bindActions() {
        cancelBarButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                if owner.reactor!.currentState.hasChanges {
                    switch UIDevice.current.allowedIdiom {
                    case .iPhone:
                        owner.presentDismissActionSheet {
                            owner.delegate?.viewControllerMustBeDismissed(owner)
                        }
                    case .iPad:
                        owner.presentDismissPopover(on: owner.cancelBarButton) {
                            owner.delegate?.viewControllerMustBeDismissed(owner)
                        }
                    }
                } else {
                    owner.delegate?.viewControllerMustBeDismissed(owner)
                }
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - Bind Reactor

extension WordDetailViewController: View {

    func bind(reactor: WordDetailReactor) {
        // MARK: Action

        self.rx.sentMessage(#selector(self.viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        doneBarButton.rx.tap
            .doOnNext { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.viewControllerMustBeDismissed(self)
            }
            .map { Reactor.Action.doneEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        wordTextField.rx.text.orEmpty
            .skip(1) // 초깃값("") 무시
            .distinctUntilChanged()
            .map(Reactor.Action.enteredWord)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        wordTextField.rx.text.orEmpty
            .skip(1) // 초깃값("") 무시
            .filter { $0 != reactor.originWord }
            .map { _ in Reactor.Action.beginEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // MARK: State

        reactor.state
            .map(\.hasChanges)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(self.rx.isModalInPresentation)
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.word)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(wordTextField.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.memorizationState)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, state in
                if state == .memorized {
                    (owner.memorizationStatePopupButton.menu?.children[1] as? UIAction)?.state = .on
                    owner.memorizationStatePopupButton.setTitle(LocalizedString.memorized, for: .normal)
                } else {
                    (owner.memorizationStatePopupButton.menu?.children[0] as? UIAction)?.state = .on
                    owner.memorizationStatePopupButton.setTitle(LocalizedString.memorizing, for: .normal)
                }
            }
            .disposed(by: self.disposeBag)

        // 완료 버튼 활성화/비활성화
        Driver.zip([
            reactor.state
                .map(\.enteredWordIsEmpty)
                .asDriverOnErrorJustComplete(),
            reactor.state
                .map(\.enteredWordIsDuplicated)
                .asDriverOnErrorJustComplete(),
        ]).map { !$0[0] && !$0[1] }
            .drive(doneBarButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        // 중복 단어 경고 레이블 표시/비표시
        reactor.state
            .map(\.enteredWordIsDuplicated)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, enteredWordIsDuplicated in
                owner.duplicatedWordAlertLabel.isHidden = !enteredWordIsDuplicated
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - UIAdaptivePresentationControllerDelegate

extension WordDetailViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        switch UIDevice.current.allowedIdiom {
        case .iPhone:
            self.presentDismissActionSheet {
                self.delegate?.viewControllerMustBeDismissed(self)
            }
        case .iPad:
            self.presentDismissPopover(on: cancelBarButton) {
                self.delegate?.viewControllerMustBeDismissed(self)
            }
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.viewControllerDidDismiss(self)
    }

}

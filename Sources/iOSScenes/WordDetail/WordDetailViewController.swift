//
//  WordDetailViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import iOSSupport
import ReactorKit
import SnapKit
import Then
import UIKit
import Utility

public protocol WordDetailViewControllerDelegate: AnyObject {

    func willFinishInteraction()

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
        $0.placeholder = WCString.word
        $0.borderStyle = .roundedRect
        $0.accessibilityIdentifier = AccessibilityIdentifier.WordDetail.wordTextField
    }

    lazy var memorizationStatePopupButton: UIButton = {
        var config: UIButton.Configuration = .bordered()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .label

        let button: UIButton = .init(configuration: config)

        button.menu = .init(children: [
            UIAction.init(title: WCString.memorizing) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(WCString.memorizing, for: .normal)
                self?.reactor?.action.onNext(.changeMemorizedState(.memorizing))
            },
            UIAction.init(title: WCString.memorized) { [weak self] _ in
                self?.memorizationStatePopupButton.setTitle(WCString.memorized, for: .normal)
                self?.reactor?.action.onNext(.changeMemorizedState(.memorized))
            },
        ])

        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.accessibilityIdentifier = AccessibilityIdentifier.WordDetail.memorizationStateButton

        return button
    }()

    let doneBarButton: UIBarButtonItem = .init(title: WCString.done).then {
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
        self.navigationItem.title = WCString.details

        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }

    override func bindAction() {
        cancelBarButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                if owner.reactor!.currentState.hasChanges {
                    owner.presentDismissActionSheet {
                        owner.delegate?.willFinishInteraction()
                    }
                } else {
                    owner.delegate?.willFinishInteraction()
                }
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - Bind Reactor

extension WordDetailViewController: View {

    func bind(reactor: WordDetailReactor) {
        // Action
        self.rx.sentMessage(#selector(self.viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        doneBarButton.rx.tap
            .doOnNext { [weak self] _ in self?.delegate?.willFinishInteraction() }
            .map { Reactor.Action.doneEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        wordTextField.rx.text.orEmpty
            .map(Reactor.Action.editWord)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        wordTextField.rx.text.orEmpty
            .skip(1) // 초깃값("") 무시
            .filter { $0 != reactor.originWord }
            .map { _ in Reactor.Action.beginEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.hasChanges)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(self.rx.isModalInPresentation)
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.word.word)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(wordTextField.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.word.memorizedState)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, state in
                if state == .memorized {
                    (owner.memorizationStatePopupButton.menu?.children[1] as? UIAction)?.state = .on
                    owner.memorizationStatePopupButton.setTitle(WCString.memorized, for: .normal)
                } else {
                    (owner.memorizationStatePopupButton.menu?.children[0] as? UIAction)?.state = .on
                    owner.memorizationStatePopupButton.setTitle(WCString.memorizing, for: .normal)
                }
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - UIAdaptivePresentationControllerDelegate

extension WordDetailViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentDismissActionSheet {
            self.delegate?.willFinishInteraction()
        }
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        delegate?.willFinishInteraction()
    }

}

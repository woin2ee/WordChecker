//
//  WordDetailViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/04.
//

import IOSSupport
import ReactorKit
import RxCocoa
import UIKit
import UtilitySource

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

    let ownView = WordDetailView()
    let ownNavigationItem = WordDetailNavigationItem()
    
    override var navigationItem: UINavigationItem {
        ownNavigationItem
    }

    override func loadView() {
        self.view = ownView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.presentationController?.delegate = self
    }

    override func bindActions() {
        ownNavigationItem.cancelBarButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                if owner.reactor!.currentState.hasChanges {
                    switch UIDevice.current.allowedIdiom {
                    case .iPhone:
                        owner.presentDismissActionSheet {
                            owner.delegate?.viewControllerMustBeDismissed(owner)
                        }
                    case .iPad:
                        owner.presentDismissPopover(on: owner.ownNavigationItem.cancelBarButton) {
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

        ownNavigationItem.doneBarButton.rx.tap
            .doOnNext { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.viewControllerMustBeDismissed(self)
            }
            .map { Reactor.Action.doneEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        ownView.wordTextField.rx.text.orEmpty
            .skip(1) // 초깃값("") 무시
            .distinctUntilChanged()
            .map(Reactor.Action.enteredWord)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        ownView.wordTextField.rx.text.orEmpty
            .skip(1) // 초깃값("") 무시
            .filter { $0 != reactor.originWord }
            .map { _ in Reactor.Action.beginEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        ownView.selectedMemorizationState
            .distinctUntilChanged()
            .map(Reactor.Action.changeMemorizationState)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

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
            .drive(ownView.wordTextField.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.memorizationState)
            .distinctUntilChanged()
            .asDriver { error in
                logger.error("\(error)")
                return .just(.memorizing)
            }
            .drive(ownView.memorizationStateBinder)
            .disposed(by: disposeBag)
        
        // 완료 버튼 활성화/비활성화
        Driver.zip([
            reactor.state
                .map(\.enteredWordIsEmpty)
                .asDriverOnErrorJustComplete(),
            reactor.state
                .map(\.enteredWordIsDuplicated)
                .asDriverOnErrorJustComplete(),
        ]).map { !$0[0] && !$0[1] }
            .drive(ownNavigationItem.doneBarButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        // 중복 단어 경고 레이블 표시/비표시
        reactor.state
            .map(\.enteredWordIsDuplicated)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, enteredWordIsDuplicated in
                owner.ownView.duplicatedWordAlertLabel.isHidden = !enteredWordIsDuplicated
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
            self.presentDismissPopover(on: ownNavigationItem.cancelBarButton) {
                self.delegate?.viewControllerMustBeDismissed(self)
            }
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.viewControllerDidDismiss(self)
    }

}

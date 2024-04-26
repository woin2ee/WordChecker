//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSSupport
import ReactorKit
import RxSwift
import RxCocoa
import RxSwiftSugar
import SFSafeSymbols
import Then
import Toast
import UIKit
import UIKitPlus
import Utility
import WebKit

public protocol WordCheckingViewControllerProtocol: UIViewController {}

final class WordCheckingViewController: RxBaseViewController, View, WordCheckingViewControllerProtocol {

    let rootView: WordCheckingView = .init()
    let ownNavigationItem = WordCheckingNavigationItem()

    override func loadView() {
        self.view = rootView
    }
    
    override var navigationItem: UINavigationItem {
        return ownNavigationItem
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.left, .right]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarAppearance()

        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance: UINavigationBarAppearance = .init()
        appearance.configureWithOpaqueBackground()

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func bind(reactor: WordCheckingReactor) {
        // Action
        self.rx.sentMessage(#selector(self.viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ownNavigationItem.addWordButton.rx.tap
            .flatMapFirst { _ in
                return self.presentAddWordAlert()
            }
            .map { Reactor.Action.addWord($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap
            .doOnNext { HapticGenerator.shared.selectionChanged() }
            .map { Reactor.Action.updateToNextWord }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.previousButton.rx.tap
            .doOnNext { HapticGenerator.shared.selectionChanged() }
            .map { Reactor.Action.updateToPreviousWord }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        ownNavigationItem.tapMemorizedMenu
            .map { Reactor.Action.markCurrentWordAsMemorized }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ownNavigationItem.tapShuffleOrderMenu
            .map { Reactor.Action.shuffleWordList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ownNavigationItem.tapDeleteWordMenu
            .map { Reactor.Action.deleteCurrentWord }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rootView.translateButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                guard NetworkMonitor.shared.isEstablishedConnection else {
                    owner.presentOKAlert(title: nil, message: LocalizedString.please_check_your_network_connection)
                    return
                }

                guard let word = reactor.currentState.currentWord?.word else {
                    assertionFailure("현재 표시된 단어가 없는데 번역 버튼이 활성화된 것으로 예상.")
                    return
                }

                let translationSite: TranslationSite = .init(
                    translationSourceLanguage: reactor.currentState.translationSourceLanguage,
                    translationTargetLanguage: reactor.currentState.translationTargetLanguage
                )

                let translationWebViewController: TranslationWebViewController = .init(translationSite: translationSite)
                translationWebViewController.word = word

                do {
                    try translationWebViewController.loadWebView()
                } catch {
                    owner.presentOKAlert(title: LocalizedString.notice, message: LocalizedString.translation_site_alert_message)
                }

                owner.navigationController?.pushViewController(translationWebViewController, animated: true)
            })
            .disposed(by: disposeBag)

        // State
        reactor.state
            .map(\.currentWord)
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, word in
                if let currentWord = word {
                    owner.rootView.wordLabel.text = currentWord.word
                    owner.rootView.wordLabel.textColor = .label
                    owner.rootView.translateButton.isEnabled = true
                } else {
                    owner.rootView.wordLabel.text = LocalizedString.noWords
                    owner.rootView.wordLabel.textColor = .systemGray2
                    owner.rootView.translateButton.isEnabled = false
                }

                owner.setAccessibilityLanguage()
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.translationSourceLanguage)
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                owner.setAccessibilityLanguage()
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$showAddCompleteToast)
            .unwrapOrIgnore()
            .asSignalOnErrorJustComplete()
            .emit(with: self) { owner, showAddCompleteToast in
                switch showAddCompleteToast {
                case .success(let word):
                    owner.view.makeToast(LocalizedString.word_added_successfully(word: word), duration: 2.0, position: .top)
                case .failure(let error):
                    switch error {
                    case .addWordFailed(reason: _, word: let word):
                        owner.view.makeToast(LocalizedString.word_added_failed(word: word), duration: 2.0, position: .top)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    func setAccessibilityLanguage() {
        if self.reactor?.currentState.currentWord == nil {
            rootView.wordLabel.accessibilityLanguage = Locale.current.language.languageCode?.identifier
        } else {
            rootView.wordLabel.accessibilityLanguage = self.reactor?.currentState.translationSourceLanguage.bcp47tag.rawValue
        }
    }

    func presentAddWordAlert() -> Maybe<String> {
        let alertController = UIAlertController(title: LocalizedString.quick_add_word, message: nil, preferredStyle: .alert)

        return .create { observer in
            let cancelAction: UIAlertAction = .init(title: LocalizedString.cancel, style: .cancel) { _ in
                observer(.completed)
            }
            alertController.addAction(cancelAction)

            let addAction: UIAlertAction = .init(title: LocalizedString.add, style: .default) { _ in
                guard let word = alertController.textFields?.first?.text else {
                    assertionFailure("Failed to get word.")
                    return
                }

                observer(.success(word))
            }
            alertController.addAction(addAction)

            alertController.addTextField { textField in
                textField.addAction(
                    UIAction { _ in
                        let text = textField.text ?? ""
                        if text.isEmpty {
                            addAction.isEnabled = false
                        } else {
                            addAction.isEnabled = true
                        }
                    },
                    for: .allEditingEvents
                )
            }

            self.present(alertController, animated: true)

            return Disposables.create()
        }
    }

}

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
import RxUtility
import SFSafeSymbols
import Then
import Toast
import UIKit
import Utility
import WebKit

public protocol WordCheckingViewControllerProtocol: UIViewController {}

final class WordCheckingViewController: RxBaseViewController, View, WordCheckingViewControllerProtocol {

    let rootView: WordCheckingView = .init()

    let addWordButton: UIBarButtonItem = .init().then {
        $0.image = .init(systemSymbol: .plusApp)
        $0.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.addWordButton
        $0.accessibilityLabel = WCString.addWord
    }

    let moreMenuButton: UIBarButtonItem = .init().then {
        $0.image = .init(systemSymbol: .ellipsisCircle)
        $0.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.moreButton
        $0.accessibilityLabel = WCString.more_menu
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.left, .right]
    }

    private func setupNavigationBar() {
        self.navigationItem.titleView = UILabel.init().then {
            $0.text = WCString.memorize_words
            $0.textColor = .clear
        }

        let appearance: UINavigationBarAppearance = .init()
        appearance.configureWithOpaqueBackground()

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationItem.rightBarButtonItems = [moreMenuButton, addWordButton]

        let menuGroup: UIMenu = .init(
            options: .displayInline,
            children: [
                UIAction(
                    title: WCString.memorized,
                    image: .init(systemSymbol: .checkmarkDiamondFill),
                    handler: { [weak self] _ in self?.reactor?.action.onNext(.markCurrentWordAsMemorized) }
                ),
                UIAction(
                    title: WCString.shuffleOrder,
                    image: .init(systemSymbol: .shuffle),
                    handler: { [weak self] _ in self?.reactor?.action.onNext(.shuffleWordList) }
                ),
            ]
        )
        let deleteMenu: UIAction = .init(
            title: WCString.deleteWord,
            image: .init(systemSymbol: .trash),
            attributes: .destructive,
            handler: { [weak self] _ in self?.reactor?.action.onNext(.deleteCurrentWord) }
        )

        moreMenuButton.menu = .init(children: [menuGroup, deleteMenu])
    }

    func bind(reactor: WordCheckingReactor) {
        // Action
        [
            self.rx.sentMessage(#selector(self.viewDidLoad))
                .map { _ in Reactor.Action.viewDidLoad },
            addWordButton.rx.tap
                .flatMapFirst { _ in
                    return self.presentAddWordAlert()
                }
                .map { Reactor.Action.addWord($0) },
            rootView.nextButton.rx.tap
                .doOnNext { HapticGenerator.shared.selectionChanged() }
                .map { Reactor.Action.updateToNextWord },
            rootView.previousButton.rx.tap
                .doOnNext { HapticGenerator.shared.selectionChanged() }
                .map { Reactor.Action.updateToPreviousWord },
        ]
            .forEach { action in
                action
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            }

        rootView.translateButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                guard NetworkMonitor.shared.isEstablishedConnection else {
                    owner.presentOKAlert(title: nil, message: WCString.please_check_your_network_connection)
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
                    owner.presentOKAlert(title: WCString.notice, message: WCString.translation_site_alert_message)
                }

                owner.navigationController?.pushViewController(translationWebViewController, animated: true)
            })
            .disposed(by: self.disposeBag)

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
                    owner.rootView.wordLabel.text = WCString.noWords
                    owner.rootView.wordLabel.textColor = .systemGray2
                    owner.rootView.translateButton.isEnabled = false
                }

                owner.setAccessibilityLanguage()
            }
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.translationSourceLanguage)
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                owner.setAccessibilityLanguage()
            }
            .disposed(by: self.disposeBag)

        reactor.pulse(\.$showAddCompleteToast)
            .asSignalOnErrorJustComplete()
            .emit(with: self) { owner, showAddCompleteToast in
                guard let showAddCompleteToast = showAddCompleteToast else { return }
                switch showAddCompleteToast {
                case .success(let word):
                    owner.view.makeToast(WCString.word_added_successfully(word: word), duration: 2.0, position: .top)
                case .failure(let error):
                    switch error {
                    case .addWordFailed(let reason):
                        switch reason {
                        case .duplicatedWord:
                            owner.view.makeToast(WCString.already_added_word, duration: 2.0, position: .top)
                        case .unknown(let word):
                            owner.view.makeToast(WCString.word_added_failed(word: word), duration: 2.0, position: .top)
                        }
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }

    func setAccessibilityLanguage() {
        if self.reactor?.currentState.currentWord == nil {
            rootView.wordLabel.accessibilityLanguage = Locale.current.language.languageCode?.identifier
        } else {
            rootView.wordLabel.accessibilityLanguage = self.reactor?.currentState.translationSourceLanguage.bcp47tag
        }
    }

    func presentAddWordAlert() -> Maybe<String> {
        let alertController = UIAlertController(title: WCString.quick_add_word, message: nil, preferredStyle: .alert)

        return .create { observer in
            let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel) { _ in
                observer(.completed)
            }
            alertController.addAction(cancelAction)

            let addAction: UIAlertAction = .init(title: WCString.add, style: .default) { _ in
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

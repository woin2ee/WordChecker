//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Combine
import Localization
import SFSafeSymbols
import SnapKit
import Then
import Toast
import UIKit
import WebKit

final class WordCheckingViewController: BaseViewController {

    let viewModel: WordCheckingViewModelProtocol

    var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - UI Objects Declaration

    let wordLabel: UILabel = {
        let label: UILabel = .init()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.wordLabel
        return label
    }()

    lazy var previousButton: ChangeWordButton = .init().then {
        let action: UIAction = .init { [weak self] _ in
            self?.viewModel.updateToPreviousWord()
        }

        $0.addAction(action, for: .touchUpInside)

        $0.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.previousButton
    }

    let previousButtonSymbol: ChangeWordSymbol = .init(direction: .left)

    lazy var nextButton: ChangeWordButton = .init().then {
        let action: UIAction = .init { [weak self] _ in
            self?.viewModel.updateToNextWord()
        }

        $0.addAction(action, for: .touchUpInside)

        $0.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.nextButton
    }

    let nextButtonSymbol: ChangeWordSymbol = .init(direction: .right)

    lazy var translateButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.translate)

        let action: UIAction = .init { [weak self] _ in
            guard let self = self else { return }

            let translationSite: TranslationSite = .init(
                translationSourceLanguage: self.viewModel.translationSourceLocale,
                translationTargetLanguage: self.viewModel.translationTargetLocale
            )

            let translationWebViewController: TranslationWebViewController = .init(translationSite: translationSite)
            translationWebViewController.word = self.wordLabel.text ?? ""

            do {
                try translationWebViewController.loadWebView()
            } catch {
                self.presentOKAlert(title: WCString.notice, message: WCString.translation_site_alert_message)
            }

            self.navigationController?.pushViewController(translationWebViewController, animated: true)
        }

        button.addAction(action, for: .touchUpInside)
        return button
    }()

    let addWordButton: UIBarButtonItem = .init().then {
        $0.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.addWordButton
    }

    let moreButton: UIBarButtonItem = {
        let buttonSymbolImage: UIImage = .init(systemSymbol: .ellipsisCircle)
        let barButton: UIBarButtonItem = .init(image: buttonSymbolImage)
        barButton.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.moreButton
        return barButton
    }()

    // MARK: - Initializers

    init(viewModel: WordCheckingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
        bindViewModel()

        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.left, .right]
    }

    private func setupSubviews() {
        self.view.addSubview(previousButton)
        self.view.addSubview(previousButtonSymbol)
        self.view.addSubview(nextButton)
        self.view.addSubview(nextButtonSymbol)
        self.view.addSubview(translateButton)
        self.view.addSubview(wordLabel)

        wordLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide).inset(30)
            make.trailing.lessThanOrEqualTo(self.view.safeAreaLayoutGuide).inset(30)
        }

        previousButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.snp.centerX)
        }

        previousButtonSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(14)
        }

        nextButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.snp.centerX)
        }

        nextButtonSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(14)
        }

        translateButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
        }
    }

    private func setupNavigationBar() {
        let appearance: UINavigationBarAppearance = .init()
        appearance.configureWithOpaqueBackground()

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationItem.rightBarButtonItems = [moreButton, addWordButton]

        addWordButton.primaryAction = .init(image: .init(systemSymbol: .plusApp), handler: { [weak self] _ in
            let alertController = UIAlertController(title: WCString.quick_add_word, message: nil, preferredStyle: .alert)

            let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)
            alertController.addAction(cancelAction)

            let addAction: UIAlertAction = .init(title: WCString.add, style: .default) { [weak self] _ in
                guard let word = alertController.textFields?.first?.text else {
                    assertionFailure("Failed to get word.")
                    return
                }

                self?.viewModel.addWord(word)

                self?.view.makeToast(WCString.word_added_successfully(word: word), duration: 1.2, position: .top)
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

            self?.present(alertController, animated: true)
        })

        let menuGroup: UIMenu = .init(options: .displayInline, children: [
            UIAction(
                title: WCString.memorized,
                image: .init(systemSymbol: .checkmarkDiamondFill),
                handler: { [weak self] _ in self?.viewModel.markCurrentWordAsMemorized() }
            ),
            UIAction(
                title: WCString.shuffleOrder,
                image: .init(systemSymbol: .shuffle),
                handler: { [weak self] _ in self?.viewModel.shuffleWordList() }
            ),
        ])

        let deleteMenu: UIAction = .init(
            title: WCString.deleteWord,
            image: .init(systemSymbol: .trash),
            attributes: .destructive,
            handler: { [weak self] _ in self?.viewModel.deleteCurrentWord() }
        )

        moreButton.menu = .init(children: [menuGroup, deleteMenu])
    }

    func bindViewModel() {
        viewModel.currentWord
            .receive(on: DispatchQueue.main)
            .sink { [weak self] word in
                if let currentWord = word {
                    self?.wordLabel.text = currentWord
                } else {
                    self?.wordLabel.text = WCString.noWords
                }
            }
            .store(in: &cancelBag)
    }

}

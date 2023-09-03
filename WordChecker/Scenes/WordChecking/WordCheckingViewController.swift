//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Combine
import UIKit
import WebKit

final class WordCheckingViewController: UIViewController {

    private var cancellableBag: Set<AnyCancellable> = .init()

    private let viewModel: WordCheckingViewModel

    let wordLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        return label
    }()

    lazy var previousButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.previous)
        let action: UIAction = .init { [weak self] _ in
            self?.viewModel.updateToPreviousWord()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    lazy var nextButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.next)
        button.addAction(.init { [weak self] _ in
            self?.viewModel.updateToNextWord()
        }, for: .touchUpInside)
        return button
    }()

    lazy var listButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.list)
        let action: UIAction = .init { [weak self] _ in
            let wordListViewController: WordListViewController = DIContainer.shared.resolve()
            self?.navigationController?.pushViewController(wordListViewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.listButton
        return button
    }()

    lazy var translateButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.translate)
        let action: UIAction = .init { [weak self] _ in
            let webView: WKWebView = .init()
            guard
                let currentWord = self?.viewModel.currentWord?.word,
                let encodedURL = "https://papago.naver.com/?sk=en&tk=ko&hn=0&st=\(currentWord)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: encodedURL)
            else {
                return
            }
            let urlRequest: URLRequest = .init(url: url)
            webView.load(urlRequest)
            let webViewController: UIViewController = .init()
            webViewController.view = webView
            self?.navigationController?.pushViewController(webViewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    let moreButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init(image: .init(systemName: "ellipsis.circle"))
        button.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.moreButton
        return button
    }()

    init(viewModel: WordCheckingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function)---\(#file)---\(#line)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    private func setupSubviews() {
        self.view.addSubview(wordLabel)
        self.view.addSubview(listButton)
        self.view.addSubview(previousButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(translateButton)

        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3.0),
            wordLabel.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: 3.0),
            wordLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])

        let buttonCollectionSpacingToSafeArea: CGFloat = 20.0
        // list button
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: buttonCollectionSpacingToSafeArea),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: previousButton.bottomAnchor, multiplier: 1.0)
        ])
        // next button
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalToSystemSpacingAfter: previousButton.trailingAnchor, multiplier: 1.0),
            nextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonCollectionSpacingToSafeArea),
            nextButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 1.0)
        ])
        // list button
        NSLayoutConstraint.activate([
            listButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: buttonCollectionSpacingToSafeArea),
            previousButton.topAnchor.constraint(equalToSystemSpacingBelow: listButton.bottomAnchor, multiplier: 1.0),
            listButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor)
        ])
        // translate button
        NSLayoutConstraint.activate([
            translateButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: translateButton.trailingAnchor, constant: buttonCollectionSpacingToSafeArea),
            nextButton.topAnchor.constraint(equalToSystemSpacingBelow: translateButton.bottomAnchor, multiplier: 1.0)
        ])
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = moreButton
        let menu: UIMenu = .init(children: [
            UIAction(title: WCString.addWord, image: .init(systemName: "plus.app"), handler: { [weak self] _ in
                let alertController = UIAlertController(title: WCString.addWord, message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)
                let addAction: UIAlertAction = .init(title: WCString.add, style: .default) { [weak self] _ in
                    guard let word = alertController.textFields?.first?.text else {
                        return
                    }
                    self?.viewModel.saveNewWord(word)
                }
                alertController.addAction(cancelAction)
                alertController.addAction(addAction)
                alertController.addTextField { textField in
                    let action: UIAction = .init { _ in
                        let text = textField.text ?? ""
                        if text.isEmpty {
                            addAction.isEnabled = false
                        } else {
                            addAction.isEnabled = true
                        }
                    }
                    textField.addAction(action, for: .allEditingEvents)
                }
                self?.present(alertController, animated: true)
            }),
            UIAction(title: WCString.shuffleOrder, image: .init(systemName: "shuffle"), handler: { [weak self] _ in
                self?.viewModel.shuffleWordList()
            }),
            UIAction(
                title: WCString.deleteWord,
                image: .init(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration.init(hierarchicalColor: .systemRed)),
                attributes: .destructive,
                handler: { [weak self] _ in
                    self?.viewModel.deleteCurrentWord()
                }
            )
        ])
        moreButton.menu = menu
    }

    private func bindViewModel() {
        viewModel.$currentWord
            .sink { [weak self] word in
                if let word = word {
                    self?.wordLabel.text = word.word
                } else {
                    self?.wordLabel.text = WCString.noWords
                }
            }
            .store(in: &cancellableBag)
    }

}

//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Combine
import SFSafeSymbols
import SnapKit
import UIKit
import WebKit

final class WordCheckingViewController: UIViewController {

    let viewModel: WordCheckingViewModelProtocol

    var cancelBag: Set<AnyCancellable> = .init()

    let wordLabel: UILabel = {
        let label: UILabel = .init()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.accessibilityIdentifier = AccessibilityIdentifier.WordChecking.wordLabel
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

    lazy var translateButton: BottomButton = {
        let button: BottomButton = .init(title: WCString.translate)
        let action: UIAction = .init { [weak self] _ in
            // TODO: 현재 앱에 설정된 언어에 따라 번역 언어 변경 기능
            guard
                let currentWord = self?.wordLabel.text,
                let encodedURL = "https://translate.google.co.kr/?sl=auto&tl=ko&text=\(currentWord)&op=translate".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: encodedURL)
            else {
                return
            }
            let urlRequest: URLRequest = .init(url: url)
            let webView: WKWebView = .init()
            webView.load(urlRequest)
            let webViewController: UIViewController = .init()
            webViewController.view = webView
            self?.navigationController?.pushViewController(webViewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

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
        self.view.backgroundColor = .systemBackground
        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    private func setupSubviews() {
        self.view.addSubview(wordLabel)
        self.view.addSubview(previousButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(translateButton)

        wordLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.leading.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide).inset(30)
            make.trailing.lessThanOrEqualTo(self.view.safeAreaLayoutGuide).inset(30)
        }
        previousButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(previousButton.snp.trailing).offset(8)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(previousButton)
        }
        translateButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-8)
            make.width.equalTo(previousButton)
        }
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
                    self?.viewModel.addWord(word)
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

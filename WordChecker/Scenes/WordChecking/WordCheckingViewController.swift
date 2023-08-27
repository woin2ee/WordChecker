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
    
    let nextButton: BottomButton = .init(title: WCStrings.next)
    
    lazy var listButton: BottomButton = {
        let button: BottomButton = .init(title: WCStrings.list)
        let action: UIAction = .init { [weak self] _ in
            let wordListViewController: WordListViewController = DIContainer.shared.resolve()
            self?.navigationController?.pushViewController(wordListViewController, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.accessibilityIdentifier = WCScene.WordChecking.AccessibilityIdentifier.listButton
        return button
    }()
    
    let shuffleButton: BottomButton = .init(title: WCStrings.shuffleOrder)
    
    lazy var translateButton: BottomButton = {
        let button: BottomButton = .init(title: WCStrings.translate)
        let action: UIAction = .init { [weak self] _ in
            let webView: WKWebView = .init()
            guard
                let currentWord = self?.viewModel.currentWord?.word,
                let url = URL(string: "https://papago.naver.com/?sk=en&tk=ko&hn=1&st=\(currentWord)")
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
    
    let addWordButton: UIBarButtonItem = .init(systemItem: .add)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateWordList()
    }
    
    private func setupSubviews() {
        self.view.addSubview(wordLabel)
        self.view.addSubview(listButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(shuffleButton)
        self.view.addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3.0),
            wordLabel.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: 3.0),
            wordLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        let buttonCollectionSpacingToSafeArea: CGFloat = 20.0
        // list button
        NSLayoutConstraint.activate([
            listButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: buttonCollectionSpacingToSafeArea),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: listButton.bottomAnchor, multiplier: 1.0),
        ])
        // next button
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalToSystemSpacingAfter: listButton.trailingAnchor, multiplier: 1.0),
            nextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonCollectionSpacingToSafeArea),
            nextButton.widthAnchor.constraint(equalTo: listButton.widthAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 1.0),
        ])
        // shuffle button
        NSLayoutConstraint.activate([
            shuffleButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: buttonCollectionSpacingToSafeArea),
            shuffleButton.widthAnchor.constraint(equalTo: listButton.widthAnchor),
            listButton.topAnchor.constraint(equalToSystemSpacingBelow: shuffleButton.bottomAnchor, multiplier: 1.0),
        ])
        // translate button
        NSLayoutConstraint.activate([
            translateButton.leadingAnchor.constraint(equalToSystemSpacingAfter: shuffleButton.trailingAnchor, multiplier: 1.0),
            translateButton.widthAnchor.constraint(equalTo: shuffleButton.widthAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: translateButton.trailingAnchor, constant: buttonCollectionSpacingToSafeArea),
            nextButton.topAnchor.constraint(equalToSystemSpacingBelow: translateButton.bottomAnchor, multiplier: 1.0),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = addWordButton
    }
    
    private func bindViewModel() {
        viewModel.$currentWord
            .sink { [weak self] word in
                if let word = word {
                    self?.wordLabel.text = word.word
                } else {
                    self?.wordLabel.text = WCStrings.noWords
                }
            }
            .store(in: &cancellableBag)
        
        shuffleButton.addAction(.init { [weak self] _ in
            self?.viewModel.shuffleWordList()
        }, for: .touchUpInside)
        
        nextButton.addAction(.init { [weak self] _ in
            self?.viewModel.updateToNextWord()
        }, for: .touchUpInside)
        
        addWordButton.primaryAction = .init { [weak self] _ in
            let alertController = UIAlertController(title: WCStrings.addWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCStrings.cancel, style: .cancel)
            let addAction: UIAlertAction = .init(title: WCStrings.add, style: .default) { [weak self] _ in
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
        }
    }
    
}

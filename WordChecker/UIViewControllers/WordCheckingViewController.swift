//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import UIKit

final class WordCheckingViewController: UIViewController {
    
    let wcRealm: WCRepository
    
    var words: [Word] = []
    
    var wordsIterator: IndexingIterator<[Word]>?
    
    let wordLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nextButton: UIButton = {
        var config: UIButton.Configuration = .filled()
        config.baseForegroundColor = .systemBackground
        config.baseBackgroundColor = .systemOrange
        config.buttonSize = .large
        var title: AttributedString = .init(stringLiteral: WCStrings.next)
        title.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        config.attributedTitle = title
        let action: UIAction = .init { [weak self] _ in
            guard let self = self, self.words.isNotEmpty else { return }
            if let nextWord = self.wordsIterator?.next() {
                self.wordLabel.text = nextWord.word
            } else {
                self.wordsIterator = self.words.makeIterator()
                self.wordLabel.text = self.wordsIterator?.next()?.word
            }
        }
        let button: UIButton = .init(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addWordButton: UIBarButtonItem = .init(systemItem: .add)
    
    init(wcRealm: WCRepository) {
        self.wcRealm = wcRealm
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
        words = wcRealm.getAllWords().shuffled()
        wordsIterator = words.makeIterator()
        if let word = wordsIterator?.next() {
            wordLabel.text = word.word
        } else {
            wordLabel.text = WCStrings.noWords
        }
    }
    
    private func setupSubviews() {
        self.view.addSubview(wordLabel)
        self.view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3.0),
            wordLabel.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: 3.0),
            wordLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = addWordButton
        addWordButton.primaryAction = .init { [weak self] _ in
            let alertController = UIAlertController(title: WCStrings.addWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCStrings.cancel, style: .cancel)
            let addAction: UIAlertAction = .init(title: WCStrings.add, style: .default) { [weak self] _ in
                guard let wordString = alertController.textFields?.first?.text else {
                    return
                }
                let word: Word = .init(word: wordString)
                try? self?.wcRealm.saveWord(word)
                self?.words.append(word)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField {
                let action: UIAction = .init { _ in
                    if let textField = alertController.textFields?.first {
                        let text = textField.text ?? ""
                        if text.isEmpty {
                            addAction.isEnabled = false
                        } else {
                            addAction.isEnabled = true
                        }
                    }
                }
                $0.addAction(action, for: .allEditingEvents)
            }
            self?.present(alertController, animated: true)
        }
    }
}

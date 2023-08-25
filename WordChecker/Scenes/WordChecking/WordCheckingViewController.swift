//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Combine
import UIKit

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
            let wordListViewModel: WordListViewModel = .init(wcRealm: .shared)
            let wordListViewController: WordListViewController = .init(viewModel: wordListViewModel)
            self?.navigationController?.pushViewController(wordListViewController, animated: true)
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
    
    private func setupSubviews() {
        self.view.addSubview(wordLabel)
        self.view.addSubview(listButton)
        self.view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3.0),
            wordLabel.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: 3.0),
            wordLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            listButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            listButton.bottomAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalToSystemSpacingAfter: listButton.trailingAnchor, multiplier: 1.0),
            nextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalTo: listButton.widthAnchor),
            nextButton.bottomAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
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

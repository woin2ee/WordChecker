//
//  WordCheckingViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import UIKit

final class WordCheckingViewController: UIViewController {
    
    let wordLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Distribution Distribution Distribution Distribution Distribution Distribution"
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
            print("tap!")
        }
        let button: UIButton = .init(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addWordButton: UIBarButtonItem = .init(systemItem: .add)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupSubviews()
        setupNavigationBar()
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
        addWordButton.primaryAction = .init(handler: { [weak self] _ in
            let alertController = UIAlertController(title: WCStrings.addWord, message: "", preferredStyle: .alert)
            alertController.addTextField()
            let cancelAction: UIAlertAction = .init(title: WCStrings.cancel, style: .cancel)
            let addAction: UIAlertAction = .init(title: WCStrings.add, style: .default) { [weak self] _ in
                print(alertController.textFields?.first?.text)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            self?.present(alertController, animated: true)
        })
    }
}

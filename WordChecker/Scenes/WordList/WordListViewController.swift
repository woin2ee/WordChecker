//
//  WordListViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Combine
import UIKit

final class WordListViewController: UIViewController {
    
    private var cancellableBag: Set<AnyCancellable> = .init()
    
    let viewModel: WordListViewModel
    
    var cellReuseIdentifier: String = "WORD_LIST_CELL"
    
    lazy var wordListTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    init(viewModel: WordListViewModel) {
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
        self.view.addSubview(wordListTableView)
        
        NSLayoutConstraint.activate([
            wordListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            wordListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            wordListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            wordListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = WCStrings.wordList
    }
    
    private func bindViewModel() {
        viewModel.$words
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.wordListTableView.reloadData()
            }
            .store(in: &cancellableBag)
    }
    
}

extension WordListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        var config: UIListContentConfiguration = .cell()
        config.text = viewModel.words[indexPath.row].word
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: WCStrings.delete) { [weak self] action, view, completionHandler in
            self?.viewModel.deleteWord(for: indexPath)
            completionHandler(true)
        }
        return .init(actions: [deleteAction])
    }
    
}

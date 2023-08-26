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
        let searchController: UISearchController = .init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    private func bindViewModel() {
        viewModel.$wordList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.wordListTableView.reloadData()
            }
            .store(in: &cancellableBag)
    }
    
}

extension WordListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        var config: UIListContentConfiguration = .cell()
        config.text = viewModel.wordList[indexPath.row].word
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: WCStrings.delete) { [weak self] action, view, completionHandler in
            self?.viewModel.deleteWord(for: indexPath)
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: WCStrings.edit) { [weak self] action, view, completionHandler in
            let alertController = UIAlertController(title: WCStrings.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCStrings.cancel, style: .cancel)
            let addAction: UIAlertAction = .init(title: WCStrings.edit, style: .default) { [weak self] _ in
                guard let newWord = alertController.textFields?.first?.text else {
                    return
                }
                self?.viewModel.editWord(for: indexPath, toNewWord: newWord)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            alertController.addTextField { [weak self] textField in
                textField.text = self?.viewModel.wordList[indexPath.row].word
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
            completionHandler(true)
        }
        return .init(actions: [deleteAction, editAction])
    }
    
}

extension WordListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.viewModel.filterWordList(with: text)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.updateWordList()
    }
    
}

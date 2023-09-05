//
//  WordSearchResultsController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Domain
import ReSwift
import StateStore
import UIKit

final class WordSearchResultsController: UITableViewController {

    let store: StateStore

    var wordList: [Word] {
        store.state.wordState.wordList
    }

    let cellReuseIdentifier = "WORD_SEARCH_RESULT_CELL"

    private var searchedList: [Word] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private var currentSearchBarText: String = "" {
        didSet {
            updateSearchedList(with: currentSearchBarText)
        }
    }

    init(store: StateStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        self.store.subscribe(self) {
            $0.select(\.wordState)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    private func updateSearchedList(with text: String) {
        let keyword = text.lowercased()
        searchedList = wordList.filter { $0.word.lowercased().contains(keyword) }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension WordSearchResultsController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        var config: UIListContentConfiguration = .cell()
        config.text = searchedList[indexPath.row].word
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: WCString.delete) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let targetItem = self.searchedList[indexPath.row]
            guard let index = self.wordList.firstIndex(of: targetItem) else { return }
            self.store.dispatch(WordStateAction.deleteWord(index: index))
            self.updateSearchedList(with: currentSearchBarText)
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: WCString.edit) { [weak self] action, _, completionHandler in
            let alertController = UIAlertController(title: WCString.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)
            let completeAction: UIAlertAction = .init(title: WCString.edit, style: .default) { [weak self] _ in
                guard let self = self, let newWord = alertController.textFields?.first?.text else { return }
                let editedWord = self.searchedList[indexPath.row]
                guard let index = self.wordList.firstIndex(of: editedWord) else { return }
                self.store.dispatch(WordStateAction.editWord(index: index, newWord: newWord))
                self.updateSearchedList(with: currentSearchBarText)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(completeAction)
            alertController.addTextField { [weak self] textField in
                guard let self = self else { return }
                let targetItem = self.searchedList[indexPath.row]
                guard let index = self.wordList.firstIndex(of: targetItem) else { return }
                textField.text = self.wordList[index].word
                let action: UIAction = .init { _ in
                    let text = textField.text ?? ""
                    if text.isEmpty {
                        completeAction.isEnabled = false
                    } else {
                        completeAction.isEnabled = true
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

// MARK: - UISearchResultsUpdating

extension WordSearchResultsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        currentSearchBarText = text
    }

}

// MARK: - StoreSubscriber

extension WordSearchResultsController: StoreSubscriber {

    func newState(state: WordState) {
        updateSearchedList(with: currentSearchBarText)
    }

}

//
//  WordSearchResultsController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Domain_Word
import IOSSupport
import ReactorKit
import SwinjectExtension
import UIKit
import UseCase_Word

public protocol WordSearchResultsControllerDelegate: AnyObject {

    func didTapWordRow(with uuid: UUID)

}

final class WordSearchResultsController: UITableViewController, View {

    var disposeBag: RxSwift.DisposeBag = .init()

    let cellReuseIdentifier = "WORD_SEARCH_RESULT_CELL"

    weak var delegate: WordSearchResultsControllerDelegate?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    private func updateSearchedList(with text: String) {
        let keyword = text.lowercased()
        searchedList = self.reactor!.currentState.wordList.filter { $0.word.lowercased().contains(keyword) }
    }

    func bind(reactor: WordListReactor) {
        // State
        reactor.state
            .map(\.wordList)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                owner.updateSearchedList(with: self.currentSearchBarText)
            }
            .disposed(by: self.disposeBag)
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

        switch searchedList[indexPath.row].memorizedState {
        case .memorized:
            cell.accessoryType = .checkmark
        case .memorizing:
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: LocalizedString.delete) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let targetItem = self.searchedList[indexPath.row]
            guard let index = self.reactor?.currentState.wordList.firstIndex(of: targetItem) else { return }
            self.reactor?.action.onNext(.deleteWord(index))
            self.updateSearchedList(with: currentSearchBarText)
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: LocalizedString.edit) { [weak self] action, _, completionHandler in
            let alertController = UIAlertController(title: LocalizedString.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: LocalizedString.cancel, style: .cancel)
            let completeAction: UIAlertAction = .init(title: LocalizedString.edit, style: .default) { [weak self] _ in
                guard let self = self, let newWord = alertController.textFields?.first?.text else { return }
                let editedWord = self.searchedList[indexPath.row]
                guard let index = self.reactor?.currentState.wordList.firstIndex(of: editedWord) else { return }
                self.reactor?.action.onNext(.editWord(newWord, index))
                self.updateSearchedList(with: currentSearchBarText)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(completeAction)
            alertController.addTextField { [weak self] textField in
                guard let self = self else { return }
                let targetItem = self.searchedList[indexPath.row]
                guard let index = self.reactor?.currentState.wordList.firstIndex(of: targetItem) else { return }
                textField.text = self.reactor?.currentState.wordList[index].word
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let uuid: UUID = searchedList[indexPath.row].uuid
        delegate?.didTapWordRow(with: uuid)
    }

}

// MARK: - UISearchResultsUpdating

extension WordSearchResultsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        currentSearchBarText = text
    }

}

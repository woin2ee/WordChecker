//
//  WordListViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Combine
import UIKit

final class WordListViewController: UIViewController {

    let viewModel: WordListViewModelProtocol

    var cancelBag: Set<AnyCancellable> = .init()

    var cellReuseIdentifier: String = "WORD_LIST_CELL"

    lazy var wordListTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()

    let addWordButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init(systemItem: .add)
        button.accessibilityIdentifier = AccessibilityIdentifier.WordList.addWordButton
        button.style = .done
        return button
    }()

    init(viewModel: WordListViewModelProtocol) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshWordList()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        wordListTableView.frame = .init(origin: .zero, size: size)
    }

    private func setupSubviews() {
        self.view.addSubview(wordListTableView)
        wordListTableView.frame = self.view.frame
    }

    private func setupNavigationBar() {
        self.navigationItem.title = WCString.wordList

        setupSearchBar()

        self.navigationItem.rightBarButtonItem = addWordButton
        addWordButton.primaryAction = .init(handler: { [weak self] _ in
            let wordAdditionVC: WordAdditionViewController = DIContainer.shared.resolve()
            let wordAdditionNC: UINavigationController = .init(rootViewController: wordAdditionVC)
            self?.present(wordAdditionNC, animated: true)
        })
    }

    func setupSearchBar() {
        let searchResultsController: WordSearchResultsController = .init(viewModel: viewModel)
        let searchController: UISearchController = .init(searchResultsController: searchResultsController)

        searchController.searchResultsUpdater = searchResultsController
        searchController.delegate = self

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    func bindViewModel() {
        viewModel.wordListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.wordListTableView.reloadData()
            }
            .store(in: &cancelBag)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

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
        let deleteAction: UIContextualAction = .init(style: .destructive, title: WCString.delete) { [weak self] _, _, completionHandler in
            self?.viewModel.deleteWord(index: indexPath.row)
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: WCString.edit) { [weak self] action, _, completionHandler in
            let alertController = UIAlertController(title: WCString.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)
            let completeAction: UIAlertAction = .init(title: WCString.edit, style: .default) { [weak self] _ in
                guard let newWord = alertController.textFields?.first?.text else {
                    return
                }
                self?.viewModel.editWord(index: indexPath.row, newWord: newWord)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(completeAction)
            alertController.addTextField { [weak self] textField in
                textField.text = self?.viewModel.wordList[indexPath.row].word
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid: UUID = viewModel.wordList[indexPath.row].uuid
        let viewController: WordDetailViewController = DIContainer.shared.resolve(arguments: uuid, viewModel as? WordDetailViewModelDelegate)
        let navigationController: UINavigationController = .init(rootViewController: viewController)
        self.present(navigationController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UISearchControllerDelegate

extension WordListViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.view.backgroundColor = .systemBackground
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.4) {
            searchController.view.backgroundColor = .clear
        }
    }

}

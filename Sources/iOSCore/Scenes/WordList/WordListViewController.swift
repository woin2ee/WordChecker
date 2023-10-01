//
//  WordListViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Combine
import SFSafeSymbols
import SnapKit
import Then
import UIKit

final class WordListViewController: BaseViewController {

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

    lazy var segmentedControl: UISegmentedControl = .init().then {
        let showAllListAction: UIAction = .init(title: WCString.all) { [weak self] _ in
            self?.viewModel.refreshWordList(by: .all)
        }

        let showUnmemorizedListAction: UIAction = .init(title: WCString.memorizing) { [weak self] _ in
            self?.viewModel.refreshWordList(by: .unmemorized)
        }

        let showMemorizedListAction: UIAction = .init(title: WCString.memorized) { [weak self] _ in
            self?.viewModel.refreshWordList(by: .memorized)
        }

        $0.insertSegment(action: showAllListAction, at: 0, animated: false)
        $0.insertSegment(action: showUnmemorizedListAction, at: 1, animated: false)
        $0.insertSegment(action: showMemorizedListAction, at: 2, animated: false)

        $0.selectedSegmentIndex = 0
    }

    let noWordListLabel: UILabel = .init().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = .preferredFont(forTextStyle: .title3, weight: .medium)
        $0.text = WCString.there_are_no_words
        $0.textColor = .systemGray3
        $0.isHidden = true
    }

    init(viewModel: WordListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.refreshWordListByCurrentType()
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
        self.view.addSubview(noWordListLabel)

        wordListTableView.frame = self.view.frame

        noWordListLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
        }
    }

    private func setupNavigationBar() {
        self.navigationItem.titleView = segmentedControl

        setupSearchBar()

        self.navigationItem.rightBarButtonItem = addWordButton
        addWordButton.primaryAction = .init(handler: { [weak self] _ in
            let wordAdditionVC: WordAdditionViewController = DIContainer.shared.resolve(argument: self?.viewModel as? WordAdditionViewModelDelegate)
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
            .sink { [weak self] wordList in
                self?.wordListTableView.reloadData()

                self?.noWordListLabel.isHidden = !wordList.isEmpty
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

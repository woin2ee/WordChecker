//
//  WordListViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import iOSSupport
import ReactorKit
import RxUtility
import SFSafeSymbols
import SnapKit
import Then
import UIKit

public protocol WordListViewControllerDelegate: AnyObject {

    func didTapWordRow(with uuid: UUID)

    func didTapAddWordButton()

}

public final class WordListViewController: RxBaseViewController {

    var cellReuseIdentifier: String = "WORD_LIST_CELL"

    public weak var delegate: WordListViewControllerDelegate?

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
            self?.reactor?.action.onNext(.refreshWordList(.all))
        }

        let showUnmemorizedListAction: UIAction = .init(title: WCString.memorizing) { [weak self] _ in
            self?.reactor?.action.onNext(.refreshWordList(.unmemorized))
        }

        let showMemorizedListAction: UIAction = .init(title: WCString.memorized) { [weak self] _ in
            self?.reactor?.action.onNext(.refreshWordList(.memorized))
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
    }

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupNavigationBar()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.reactor?.action.onNext(.refreshWordListByCurrentType)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
        self.navigationItem.rightBarButtonItem = addWordButton
        setupSearchBar()
    }

    func setupSearchBar() {
        let searchResultsController: WordSearchResultsController = .init().then {
            $0.reactor = self.reactor
            $0.delegate = self.delegate as? WordSearchResultsControllerDelegate
        }
        let searchController: UISearchController = .init(searchResultsController: searchResultsController)

        searchController.searchResultsUpdater = searchResultsController
        searchController.delegate = self

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    public override func bindAction() {
        addWordButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.delegate?.didTapAddWordButton()
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - Reactor Binding

extension WordListViewController: View {

    public func bind(reactor: WordListReactor) {
        // Action

        // State
        reactor.state
            .map(\.wordList)
//            .distinctUntilChanged() // 첫번째 수정에 작동을 안함 why?
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, wordList in
                owner.wordListTableView.reloadData()

                owner.noWordListLabel.isHidden = !wordList.isEmpty
            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension WordListViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reactor!.currentState.wordList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        var config: UIListContentConfiguration = .cell()
        config.text = self.reactor!.currentState.wordList[indexPath.row].word

        cell.contentConfiguration = config

        switch self.reactor!.currentState.wordList[indexPath.row].memorizedState {
        case .memorized:
            cell.accessoryType = .checkmark
        case .memorizing:
            cell.accessoryType = .none
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: WCString.delete) { [weak self] _, _, completionHandler in
            self?.reactor?.action.onNext(.deleteWord(indexPath.row))
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: WCString.edit) { [weak self] action, _, completionHandler in
            let alertController = UIAlertController(title: WCString.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: WCString.cancel, style: .cancel)
            let completeAction: UIAlertAction = .init(title: WCString.edit, style: .default) { [weak self] _ in
                guard let newWord = alertController.textFields?.first?.text else {
                    return
                }
                self?.reactor?.action.onNext(.editWord(newWord, indexPath.row))
            }
            alertController.addAction(cancelAction)
            alertController.addAction(completeAction)
            alertController.addTextField { [weak self] textField in
                textField.text = self?.reactor?.currentState.wordList[indexPath.row].word
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

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid: UUID = self.reactor!.currentState.wordList[indexPath.row].uuid
        delegate?.didTapWordRow(with: uuid)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UISearchControllerDelegate

extension WordListViewController: UISearchControllerDelegate {

    public func willPresentSearchController(_ searchController: UISearchController) {
        searchController.view.backgroundColor = .systemBackground
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.4) {
            searchController.view.backgroundColor = .clear
        }
    }

}

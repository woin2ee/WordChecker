//
//  WordListViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import IOSSupport
import ReactorKit
import RxSwiftSugar
import SFSafeSymbols
import SnapKit
import Then
import UIKit

public protocol WordListViewControllerDelegate: AnyObject {

    func didTapWordRow(with uuid: UUID)

    func didTapAddWordButton()

}

public protocol WordListViewControllerProtocol: UIViewController {
    var delegate: WordListViewControllerDelegate? { get set }

    /// 단어 목록을 맨 위로 스크롤합니다.
    func scrollToTop()
}

final class WordListViewController: RxBaseViewController, WordListViewControllerProtocol {

    var cellReuseIdentifier: String = "WORD_LIST_CELL"

    weak var delegate: WordListViewControllerDelegate? {
        didSet {
            searchResultsController.delegate = delegate as? WordSearchResultsControllerDelegate
        }
    }

    private lazy var searchResultsController = WordSearchResultsController().then {
        $0.reactor = self.reactor
    }
    
    private lazy var ownNavigationItem = WordListNavigationItem().then {
        $0.attachSearchBar(searchResultsController: searchResultsController)
        $0.searchController?.delegate = self
    }
    override var navigationItem: UINavigationItem {
        ownNavigationItem
    }
    
    lazy var wordListTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()

    let noWordListLabel: UILabel = .init().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = .preferredFont(forTextStyle: .title3, weight: .medium)
        $0.text = LocalizedString.there_are_no_words
        $0.textColor = .systemGray3
    }
    
    let editingToolBar = EditingToolBar().then {
        $0.isHidden = true
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.reactor?.action.onNext(.refreshWordListByCurrentType)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        wordListTableView.frame = .init(origin: .zero, size: size)
    }

    override func viewWillLayoutSubviews() {
        wordListTableView.frame = self.view.frame
        super.viewWillLayoutSubviews()
    }

    private func setupSubviews() {
        self.view.addSubview(wordListTableView)
        self.view.addSubview(noWordListLabel)
        self.view.addSubview(editingToolBar)

        wordListTableView.frame = self.view.frame

        noWordListLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
        }
        
        editingToolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(78)
        }
    }

    override func bindActions() {
        ownNavigationItem.addWordButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.delegate?.didTapAddWordButton()
            }
            .disposed(by: self.disposeBag)
    }

    func scrollToTop() {
        if wordListTableView.visibleCells.count != 0 {
            wordListTableView.scrollToRow(at: .init(row: 0, section: 0), at: .bottom, animated: true)
        }
    }
}

// MARK: - Reactor Binding

extension WordListViewController: View {

    func bind(reactor: WordListReactor) {
        // Action
        ownNavigationItem.didSelectSortType
            .map(Reactor.Action.refreshWordList)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ownNavigationItem.editButton.rx.tap
            .map { Reactor.Action.setEditing(true) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ownNavigationItem.cancelButton.rx.tap
            .map { Reactor.Action.setEditing(false) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editingToolBar.markAsMemorizedButton.rx.tap
            .compactMap { [weak self] _ -> [IndexPath]? in
                return self?.wordListTableView.indexPathsForSelectedRows
            }
            .map(Reactor.Action.markWordsAsMemorized)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editingToolBar.deleteButton.rx.tap
            .compactMap { [weak self] _ -> [IndexPath]? in
                return self?.wordListTableView.indexPathsForSelectedRows
            }
            .map(Reactor.Action.deleteWords)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        reactor.state
            .map(\.listType)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(ownNavigationItem.listTypeBinder)
            .disposed(by: disposeBag)
        
        do { // Bind `isEditing` state of Reactor
            var isEditingBinder: Binder<Bool> {
                Binder(self) { target, isEditing in
                    target.editingToolBar.isHidden = !isEditing
                    target.tabBarController?.tabBar.isHidden = isEditing
                }
            }
            
            reactor.state
                .map(\.isEditing)
                .asDriverOnErrorJustComplete()
                .drive(
                    ownNavigationItem.isEditingBinder,
                    wordListTableView.rx.isEditing,
                    isEditingBinder
                )
                .disposed(by: disposeBag)
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension WordListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reactor!.currentState.wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        var config: UIListContentConfiguration = .cell()
        config.text = self.reactor!.currentState.wordList[indexPath.row].word

        cell.contentConfiguration = config

        switch self.reactor!.currentState.wordList[indexPath.row].memorizationState {
        case .memorized:
            cell.accessoryType = .checkmark
        case .memorizing:
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = .init(style: .destructive, title: LocalizedString.delete) { [weak self] _, _, completionHandler in
            self?.reactor?.action.onNext(.deleteWord(indexPath.row))
            completionHandler(true)
        }
        let editAction: UIContextualAction = .init(style: .normal, title: LocalizedString.edit) { [weak self] action, _, completionHandler in
            let alertController = UIAlertController(title: LocalizedString.editWord, message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: LocalizedString.cancel, style: .cancel)
            let completeAction: UIAlertAction = .init(title: LocalizedString.edit, style: .default) { [weak self] _ in
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { return }
            
        let uuid: UUID = self.reactor!.currentState.wordList[indexPath.row].uuid
        delegate?.didTapWordRow(with: uuid)
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

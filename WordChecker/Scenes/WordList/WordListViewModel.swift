//
//  WordListViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/25.
//

import Combine
import Foundation
import ReSwift

protocol WordListViewModelInput {

    func deleteWord(for indexPath: IndexPath)

    func editWord(for indexPath: IndexPath, toNewWord newWord: String)

}

final class WordListViewModel: StoreSubscriber {

    @Published var wordList: [Word] = []

    let store: AppStore

    init(store: AppStore) {
        self.store = store
        self.store.subscribe(self)
    }

    func newState(state: AppState) {
        self.wordList = state.wordList
    }

}

extension WordListViewModel: WordListViewModelInput {

    func deleteWord(for indexPath: IndexPath) {
        store.dispatch(AppStateAction.deleteWord(index: indexPath.row))
    }

    func editWord(for indexPath: IndexPath, toNewWord newWord: String) {
        store.dispatch(AppStateAction.editWord(index: indexPath.row, newWord: newWord))
    }

}

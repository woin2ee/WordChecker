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

    let store: StateStore

    init(store: StateStore) {
        self.store = store
        self.store.subscribe(self) { subscription in
            subscription.select(\.wordState)
        }
    }

    func newState(state: WordState) {
        self.wordList = state.wordList
    }

}

extension WordListViewModel: WordListViewModelInput {

    func deleteWord(for indexPath: IndexPath) {
        store.dispatch(WordStateAction.deleteWord(index: indexPath.row))
    }

    func editWord(for indexPath: IndexPath, toNewWord newWord: String) {
        store.dispatch(WordStateAction.editWord(index: indexPath.row, newWord: newWord))
    }

}

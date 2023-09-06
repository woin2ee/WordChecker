//
//  WordListViewModel.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation
import ReSwift
import StateStore

protocol WordListViewModelInput {

    func deleteWord(index: IndexPath.Index)

    func editWord(index: IndexPath.Index, newWord: String)

}

protocol WordListViewModelOutput {

    var wordListSubject: CurrentValueSubject<[Word], Never> { get }

}

protocol WordListViewModelProtocol: WordListViewModelInput, WordListViewModelOutput {}

final class WordListViewModel: WordListViewModelProtocol, StoreSubscriber {

    let store: StateStore

    let wordListSubject: CurrentValueSubject<[Domain.Word], Never> = .init([])

    init(store: StateStore) {
        self.store = store
        self.store.subscribe(self) {
            $0.select(\.wordState)
        }
    }

    func newState(state: WordState) {
        wordListSubject.send(state.wordList)
    }

}

extension WordListViewModel {

    func deleteWord(index: IndexPath.Index) {
        store.dispatch(WordStateAction.deleteWord(index: index))
    }

    func editWord(index: IndexPath.Index, newWord: String) {
        store.dispatch(WordStateAction.editWord(index: index, newWord: newWord))
    }

}

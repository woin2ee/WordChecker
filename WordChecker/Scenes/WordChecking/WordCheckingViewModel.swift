//
//  WordCheckingViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Combine
import Foundation
import ReSwift

protocol WordCheckingViewModelInput {

    func updateToNextWord()

    func updateToPreviousWord()

    func saveNewWord(_ word: String)

    func shuffleWordList()

    func deleteCurrentWord()

}

final class WordCheckingViewModel: StoreSubscriber {

    let store: StateStore

    @Published private(set) var currentWord: Word?

    init(store: StateStore) {
        self.store = store
        self.store.subscribe(self) { subscription in
            subscription.select(\.wordState)
        }
    }

    func newState(state: WordState) {
        self.currentWord = state.currentWord
    }

}

extension WordCheckingViewModel: WordCheckingViewModelInput {

    func deleteCurrentWord() {
        store.dispatch(WordStateAction.deleteCurrentWord)
    }

    func updateToNextWord() {
        store.dispatch(WordStateAction.updateToNextWord)
    }

    func updateToPreviousWord() {
        store.dispatch(WordStateAction.updateToPreviousWord)
    }

    func saveNewWord(_ word: String) {
        store.dispatch(WordStateAction.addWord(word: word))
    }

    func shuffleWordList() {
        store.dispatch(WordStateAction.shuffleWordList)
    }

}

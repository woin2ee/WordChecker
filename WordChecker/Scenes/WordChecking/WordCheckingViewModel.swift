//
//  WordCheckingViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Combine
import Foundation
import ReSwift

// enum WordCheckingError: Error {
//
//    case someError
//
// }

protocol WordCheckingViewModelInput {

    func updateToNextWord()

    func updateToPreviousWord()

    func saveNewWord(_ word: String)

    func shuffleWordList()

    func deleteCurrentWord()

}

final class WordCheckingViewModel: StoreSubscriber {

    let store: AppStore

    @Published private(set) var currentWord: Word? // Action 이 아닌 임의로 변경할 시 DB/상태 에 적용 안됨

    init(store: AppStore) {
        self.store = store
        self.store.subscribe(self)
    }

    func newState(state: AppState) {
        self.currentWord = state.currentWord
    }

}

extension WordCheckingViewModel: WordCheckingViewModelInput {

    func deleteCurrentWord() {
        store.dispatch(AppStateAction.deleteCurrentWord)
    }

    func updateToNextWord() {
        store.dispatch(AppStateAction.updateToNextWord)
    }

    func updateToPreviousWord() {
        store.dispatch(AppStateAction.updateToPreviousWord)
    }

    func saveNewWord(_ word: String) {
        store.dispatch(AppStateAction.addWord(word: word))
    }

    func shuffleWordList() {
        store.dispatch(AppStateAction.shuffleWordList)
    }

}

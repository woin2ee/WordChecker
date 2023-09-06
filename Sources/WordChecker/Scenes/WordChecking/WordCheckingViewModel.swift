//
//  WordCheckingViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation
import ReSwift
import StateStore

/// WordCheckingView 로부터 발생하고 Model 에 영향을 끼치는 모든 Event.
protocol WordCheckingViewModelInput {

    func addWord(_ word: String)

    func updateToNextWord()

    func updateToPreviousWord()

    func shuffleWordList()

    func deleteCurrentWord()

}

/// WordCheckingView 를 표시하기 위해 필요한 최소한의 Model.
protocol WordCheckingViewModelOutput {

    var currentWordSubject: CurrentValueSubject<String?, Never> { get }

}

protocol WordCheckingViewModelProtocol: WordCheckingViewModelInput, WordCheckingViewModelOutput {}

final class WordCheckingViewModel: WordCheckingViewModelProtocol, StoreSubscriber {

    let store: StateStore

    let currentWordSubject: CurrentValueSubject<String?, Never> = .init("")

    init(store: StateStore) {
        self.store = store
        self.store.subscribe(self) {
            $0.select(\.wordState)
        }
    }

    func newState(state: WordState) {
        currentWordSubject.send(state.currentWord?.word)
    }

}

extension WordCheckingViewModel {

    func addWord(_ word: String) {
        store.dispatch(WordState.Actions.addWord(word))
    }

    func updateToNextWord() {
        store.dispatch(WordState.Actions.updateToNextWord)
    }

    func updateToPreviousWord() {
        store.dispatch(WordState.Actions.updateToPreviousWord)
    }

    func shuffleWordList() {
        store.dispatch(WordState.Actions.shuffleWordList)
    }

    func deleteCurrentWord() {
        store.dispatch(WordState.Actions.deleteCurrentWord)
    }

}

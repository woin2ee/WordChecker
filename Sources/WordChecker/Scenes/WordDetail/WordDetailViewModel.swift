//
//  WordDetailViewModel.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation
import ReSwift
import StateStore

protocol WordDetailViewModelInput {

    func doneEditing()

}

protocol WordDetailViewModelOutput {

}

protocol WordDetailViewModelProtocol: WordDetailViewModelInput, WordDetailViewModelOutput {}

final class WordDetailViewModel: WordDetailViewModelProtocol, StoreSubscriber {

    let store: StateStore

    init(store: StateStore) {
        self.store = store
        self.store.subscribe(self) {
            $0.select(\.wordState)
        }
    }

    func newState(state: WordState) {

    }

}

extension WordDetailViewModel {

    func doneEditing() {

    }

}

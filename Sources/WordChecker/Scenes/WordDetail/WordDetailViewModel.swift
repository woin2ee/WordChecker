//
//  WordDetailViewModel.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation

protocol WordDetailViewModelInput {

    func doneEditing()

}

protocol WordDetailViewModelOutput {

}

protocol WordDetailViewModelProtocol: WordDetailViewModelInput, WordDetailViewModelOutput {}

final class WordDetailViewModel: WordDetailViewModelProtocol {

    let wordUseCase: WordUseCaseProtocol

    init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
    }

}

extension WordDetailViewModel {

}

extension WordDetailViewModel {

    func doneEditing() {

    }

}

//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import Foundation

protocol WordAdditionViewModelInput {

    func finishAddingWord(_ word: Word)

}

protocol WordAdditionViewModelOutput {

}

protocol WordAdditionViewModelProtocol: WordAdditionViewModelInput, WordAdditionViewModelOutput {}

final class WordAdditionViewModel: WordAdditionViewModelProtocol {

    let wordUseCase: WordUseCaseProtocol

    init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
    }

}

extension WordAdditionViewModel {

    func finishAddingWord(_ word: Word) {
        wordUseCase.addNewWord(word)

    }

}

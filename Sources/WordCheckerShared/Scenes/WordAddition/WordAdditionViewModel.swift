//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import Foundation

protocol WordAdditionViewModelDelegate: AnyObject {

    func wordAdditionViewModelDidFinishAddWord(uuid: UUID)

}

protocol WordAdditionViewModelInput {

    func finishAddingWord(_ word: Word)

}

protocol WordAdditionViewModelOutput {

}

protocol WordAdditionViewModelProtocol: WordAdditionViewModelInput, WordAdditionViewModelOutput {}

final class WordAdditionViewModel: WordAdditionViewModelProtocol {

    let wordUseCase: WordUseCaseProtocol

    private(set) var delegate: WordAdditionViewModelDelegate?

    init(wordUseCase: WordUseCaseProtocol, delegate: WordAdditionViewModelDelegate?) {
        self.wordUseCase = wordUseCase
        self.delegate = delegate
    }

}

extension WordAdditionViewModel {

    func finishAddingWord(_ word: Word) {
        wordUseCase.addNewWord(word)
        delegate?.wordAdditionViewModelDidFinishAddWord(uuid: word.uuid)
    }

}

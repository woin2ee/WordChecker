//
//  WordListViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation

protocol WordListViewModelInput {

    func deleteWord(index: IndexPath.Index)

    func editWord(index: IndexPath.Index, newWord: String)

    func refreshWordList()

}

protocol WordListViewModelOutput {

    var wordListPublisher: AnyPublisher<[Word], Never> { get }

    var wordList: [Word] { get }

}

protocol WordListViewModelProtocol: WordListViewModelInput, WordListViewModelOutput {}

final class WordListViewModel: WordListViewModelProtocol {

    let wordListSubject: CurrentValueSubject<[Domain.Word], Never> = .init([])

    let wordUseCase: WordUseCaseProtocol

    init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
        refreshWordList()
    }

}

// MARK: - Output

extension WordListViewModel {

    var wordListPublisher: AnyPublisher<[Word], Never> {
        wordListSubject.eraseToAnyPublisher()
    }

    var wordList: [Word] {
        wordListSubject.value
    }

}

// MARK: - Input

extension WordListViewModel {

    func deleteWord(index: IndexPath.Index) {
        let deleteTarget: Word = wordListSubject.value[index]
        wordUseCase.deleteWord(deleteTarget)
        let newList = wordUseCase.getWordList()
        wordListSubject.send(newList)
    }

    func editWord(index: IndexPath.Index, newWord: String) {
        let updateTargetUUID = wordListSubject.value[index].uuid
        let updateTarget: Word = .init(
            uuid: updateTargetUUID,
            word: newWord,
            isMemorized: false
        )
        wordUseCase.updateWord(with: updateTargetUUID, to: updateTarget)
        let newList = wordUseCase.getWordList()
        wordListSubject.send(newList)
    }

    func refreshWordList() {
        let wordList = wordUseCase.getWordList()
        wordListSubject.send(wordList)
    }

}

// MARK: - WordDetailViewModelDelegate

extension WordListViewModel: WordDetailViewModelDelegate {

    func wordDetailViewModelDidUpdateWord(with uuid: UUID) {
        refreshWordList()
    }

}

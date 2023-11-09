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

    func refreshWordList(by type: WordListViewModel.WordListType)

    func refreshWordListByCurrentType()

}

protocol WordListViewModelOutput {

    var wordListPublisher: AnyPublisher<[Word], Never> { get }

    var wordList: [Word] { get }

}

protocol WordListViewModelProtocol: WordListViewModelInput, WordListViewModelOutput {}

final class WordListViewModel: WordListViewModelProtocol {

    let wordListSubject: CurrentValueSubject<[Domain.Word], Never> = .init([])

    private(set) var currentListType: WordListType = .all

    let wordUseCase: WordUseCaseProtocol

    init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
        refreshWordList(by: .all)
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
        wordUseCase.deleteWord(by: deleteTarget.uuid)

        refreshWordList(by: currentListType)

        GlobalAction.shared.didDeleteWord.accept(deleteTarget)
    }

    func editWord(index: IndexPath.Index, newWord: String) {
        let updateTarget = wordListSubject.value[index]
        updateTarget.word = newWord

        wordUseCase.updateWord(by: updateTarget.uuid, to: updateTarget)

        refreshWordList(by: currentListType)

        GlobalAction.shared.didEditWord.accept(updateTarget)
    }

    func refreshWordList(by type: WordListType) {
        let wordList: [Word]

        switch type {
        case .all:
            wordList = wordUseCase.getWordList()
        case .memorized:
            wordList = wordUseCase.getMemorizedWordList()
        case .unmemorized:
            wordList = wordUseCase.getUnmemorizedWordList()
        }

        wordListSubject.send(wordList)
        currentListType = type
    }

    func refreshWordListByCurrentType() {
        refreshWordList(by: currentListType)
    }

}

// MARK: - Delegates

extension WordListViewModel: WordDetailReactorDelegate, WordAdditionViewModelDelegate {
    
    func wordDetailReactorDidUpdateWord(with uuid: UUID) {
        refreshWordList(by: currentListType)
    }

    func wordAdditionViewModelDidFinishAddWord() {
        refreshWordList(by: currentListType)
    }

}

// MARK: - WordListType

extension WordListViewModel {

    enum WordListType {

        case all

        case memorized

        case unmemorized

    }

}

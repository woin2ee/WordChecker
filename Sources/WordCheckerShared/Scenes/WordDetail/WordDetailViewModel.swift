//
//  WordDetailViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Combine
import Domain
import Foundation

protocol WordDetailViewModelDelegate: AnyObject {

    func wordDetailViewModelDidUpdateWord(with uuid: UUID)

}

protocol WordDetailViewModelInput {

    func doneEditing(_ word: Word)

    func markAsChanged()

}

protocol WordDetailViewModelOutput {

    var word: AnyPublisher<Word, Never> { get }

    var hasChangesSubject: CurrentValueSubject<Bool, Never> { get }

}

protocol WordDetailViewModelProtocol: WordDetailViewModelInput, WordDetailViewModelOutput {}

final class WordDetailViewModel: WordDetailViewModelProtocol {

    let wordUseCase: WordUseCaseProtocol

    let wordSubject: CurrentValueSubject<Domain.Word, Never> = .init(.empty)

    let hasChangesSubject: CurrentValueSubject<Bool, Never> = .init(false)

    private(set) weak var delegate: WordDetailViewModelDelegate?

    init(wordUseCase: WordUseCaseProtocol, uuid: UUID, delegate: WordDetailViewModelDelegate?) {
        self.wordUseCase = wordUseCase
        self.delegate = delegate
        if let word = wordUseCase.getWord(by: uuid) {
            wordSubject.send(word)
        } // 만약 비동기 API 통신을 이용한 fetch 일 경우 Output 에 ErrorTracker 를 추가하여 오류 상황 대처 방안
    }

}

extension WordDetailViewModel {

    var word: AnyPublisher<Word, Never> {
        wordSubject.eraseToAnyPublisher()
    }

}

extension WordDetailViewModel {

    func doneEditing(_ word: Word) {
        let updateTargetUUID: UUID = wordSubject.value.uuid
        let updateTarget: Domain.Word = .init(uuid: updateTargetUUID, word: word.word, isMemorized: word.isMemorized)
        wordUseCase.updateWord(by: updateTargetUUID, to: updateTarget)
        delegate?.wordDetailViewModelDidUpdateWord(with: updateTargetUUID)
    }

    func markAsChanged() {
        hasChangesSubject.send(true)
    }

}
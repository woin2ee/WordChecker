//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import RxUtility

protocol WordAdditionViewModelDelegate: AnyObject {

    func wordAdditionViewModelDidFinishAddWord()

}

final class WordAdditionViewModel: ViewModelType {

    let wordUseCase: WordRxUseCaseProtocol

    private(set) var delegate: WordAdditionViewModelDelegate?

    init(wordUseCase: WordRxUseCaseProtocol, delegate: WordAdditionViewModelDelegate?) {
        self.wordUseCase = wordUseCase
        self.delegate = delegate
    }

    func transform(input: Input) -> Output {
        let initialWordText = ""

        let hasChanges = input.wordText.map { $0 != initialWordText }

        let saveComplete = input.saveAttempt
            .asObservable()
            .withLatestFrom(input.wordText) { _, wordText -> Word in
                return .init(word: wordText)
            }
            .flatMapFirst { newWord in
                return self.wordUseCase.addNewWord(newWord)
            }
            .doOnNext { _ in self.delegate?.wordAdditionViewModelDidFinishAddWord() }
            .asSignalOnErrorJustComplete()

        let wordTextIsNotEmpty = input.wordText.map(\.isNotEmpty)

        let reconfirmDismiss = input.dismissAttempt
            .asObservable()
            .withLatestFrom(hasChanges)
            .filter { $0 }
            .mapToVoid()
            .asSignalOnErrorJustComplete()

        let dismissComplete = input.dismissAttempt
            .asObservable()
            .withLatestFrom(hasChanges)
            .filter { !$0 }
            .mapToVoid()
            .asSignalOnErrorJustComplete()

        return .init(
            saveComplete: saveComplete,
            wordTextIsNotEmpty: wordTextIsNotEmpty,
            reconfirmDismiss: reconfirmDismiss,
            dismissComplete: dismissComplete
        )
    }

}

extension WordAdditionViewModel {

    struct Input {

        let wordText: Driver<String>

        let saveAttempt: Signal<Void>

        let dismissAttempt: Signal<Void>

    }

    struct Output {

        let saveComplete: Signal<Void>

        let wordTextIsNotEmpty: Driver<Bool>

        let reconfirmDismiss: Signal<Void>

        let dismissComplete: Signal<Void>

    }

}

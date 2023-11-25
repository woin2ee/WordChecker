//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import Foundation
import iOSSupport
import RxSwift
import RxCocoa
import RxUtility

final class WordAdditionViewModel: ViewModelType {

    let wordUseCase: WordRxUseCaseProtocol

    init(wordUseCase: WordRxUseCaseProtocol) {
        self.wordUseCase = wordUseCase
    }

    func transform(input: Input) -> Output {
        let initialWordText = ""

        let hasChanges = input.wordText.map { $0 != initialWordText }

        let saveComplete = input.saveAttempt
            .withLatestFrom(input.wordText)
            .map { wordText -> Word in
                return .init(word: wordText)
            }
            .flatMapFirst { newWord in
                return self.wordUseCase.addNewWord(newWord)
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { _ in
                GlobalAction.shared.didAddWord.accept(())
            }

        let wordTextIsNotEmpty = input.wordText.map(\.isNotEmpty)

        let reconfirmDismiss = input.dismissAttempt
            .withLatestFrom(hasChanges)
            .filter { $0 }
            .mapToVoid()
            .asSignalOnErrorJustComplete()

        let dismissComplete = input.dismissAttempt
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

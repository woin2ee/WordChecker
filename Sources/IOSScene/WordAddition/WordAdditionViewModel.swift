//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain
import Foundation
import FoundationPlus
import IOSSupport
import RxSwift
import RxCocoa
import RxSwiftSugar

final class WordAdditionViewModel: ViewModelType {

    let wordUseCase: WordUseCaseProtocol

    init(wordUseCase: WordUseCaseProtocol) {
        self.wordUseCase = wordUseCase
    }

    func transform(input: Input) -> Output {
        let initialWordText = "" // 새 단어를 추가할때는 초기 단어가 없으므로

        let hasChanges = input.wordText.map { $0 != initialWordText }

        let saveComplete = input.saveAttempt
            .withLatestFrom(input.wordText)
            .map { wordText -> Word? in
                return try? .init(word: wordText)
            }
            .unwrapOrIgnore()
            .flatMapFirst { newWord in
                return self.wordUseCase.addNewWord(newWord)
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { _ in
                GlobalAction.shared.didAddWord.accept(())
            }

        let wordTextHasElements = input.wordText.map(\.hasElements)

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

        let enteredWordIsDuplicated = input.wordText
            .flatMapLatest { word in
                return self.wordUseCase.isWordDuplicated(word)
                    .asDriverOnErrorJustComplete()
            }

        return .init(
            saveComplete: saveComplete,
            wordTextIsNotEmpty: wordTextHasElements,
            reconfirmDismiss: reconfirmDismiss,
            dismissComplete: dismissComplete,
            enteredWordIsDuplicated: enteredWordIsDuplicated
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

        /// Dismiss 해야하는지 재확인이 필요할때 next 이벤트가 방출됩니다.
        let reconfirmDismiss: Signal<Void>

        let dismissComplete: Signal<Void>

        /// 입력되어 있는 단어가 중복된 단어인지 여부
        var enteredWordIsDuplicated: Driver<Bool>
    }

}

//
//  WordAdditionViewModel.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import Domain_Word
import Foundation
import FoundationPlus
import IOSSupport
import RxSwift
import RxCocoa
import RxSwiftSugar
import UseCase_Word

final class WordAdditionViewModel: ViewModelType {

    private let wordUseCase: WordUseCase
    private let globalState: GlobalState

    init(wordUseCase: WordUseCase, globalState: GlobalState) {
        self.wordUseCase = wordUseCase
        self.globalState = globalState
    }

    func transform(input: Input) -> Output {
        let initialWordText = "" // 새 단어를 추가할때는 초기 단어가 없으므로

        let hasChanges = input.wordText.map { $0 != initialWordText }

        let saveComplete = input.saveAttempt
            .withLatestFrom(input.wordText)
            .flatMapFirst { newWord in
                var newWord = newWord
                
                if self.globalState.autoCapitalizationIsOn {
                    newWord = newWord.prefix(1).uppercased() + newWord.dropFirst()
                }
                
                return self.wordUseCase.addNewWord(newWord)
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { _ in
                GlobalAction.shared.didAddWord.accept(())
            }

        let wordIsEntered = input.wordText.map(\.hasElements)

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
                if word.hasElements {
                    return self.wordUseCase.isWordDuplicated(word)
                        .asDriverOnErrorJustComplete()
                } else {
                    return .just(false)
                }
            }

        return .init(
            saveComplete: saveComplete,
            wordIsEntered: wordIsEntered,
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

        let wordIsEntered: Driver<Bool>

        /// Dismiss 해야하는지 재확인이 필요할때 next 이벤트가 방출됩니다.
        let reconfirmDismiss: Signal<Void>

        let dismissComplete: Signal<Void>

        /// 입력되어 있는 단어가 중복된 단어인지 여부
        var enteredWordIsDuplicated: Driver<Bool>
    }

}

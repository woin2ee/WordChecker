//
//  WordDetailReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/09.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import IOSSupport
import ReactorKit

final class WordDetailReactor: Reactor {

    enum Action {
        case viewDidLoad
        case beginEditing
        case doneEditing

        /// 현재 입력된 단어
        case enteredWord(String)

        case changeMemorizedState(MemorizedState)
    }

    enum Mutation {
        case updateWord(Word)
        case markAsEditing

        /// 현재 입력된 단어를 중복된 단어로 표시할지 결정하는 Mutation
        case setDuplicated(Bool)

        /// 현재 입력된 단어의 비어있음 상태를 결정하는 Mutation
        case setEmpty(Bool)
    }

    struct State {

        /// 현재 입력된 단어
        var word: Word

        /// 현재 화면에서 변경사항이 발생했는지 여부를 나타내는 값
        var hasChanges: Bool

        /// 입력되어 있는 단어가 중복된 단어인지 여부를 나타내는 값
        var enteredWordIsDuplicated: Bool

        /// 현재 입력된 단어가 비어있는지 여부를 나타내는 값
        var enteredWordIsEmpty: Bool
    }

    var initialState: State = State(
        word: .empty,
        hasChanges: false,
        enteredWordIsDuplicated: false,
        enteredWordIsEmpty: false // Detail 화면에서는 항상 초기 단어가 있으므로
    )

    /// 현재 보여지고 있는 단어의 UUID 입니다.
    let uuid: UUID

    /// 편집되기 전 원래 단어입니다. viewDidLoad 가 호출될 때 초기화됩니다.
    private(set) var originWord: String?

    let globalAction: GlobalAction
    let wordUseCase: WordUseCaseProtocol

    init(
        uuid: UUID,
        globalAction: GlobalAction,
        wordUseCase: WordUseCaseProtocol
    ) {
        self.uuid = uuid
        self.globalAction = globalAction
        self.wordUseCase = wordUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return wordUseCase.getWord(by: uuid)
                .doOnSuccess {
                    self.originWord = $0.word
                }
                .asObservable()
                .map(Mutation.updateWord)

        case .beginEditing:
            return .just(.markAsEditing)

        case .doneEditing:
            return wordUseCase.updateWord(by: uuid, to: self.currentState.word)
                .doOnSuccess { _ in
                    self.globalAction.didEditWord.accept(self.currentState.word)
                }
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in return .empty() }

        case .enteredWord(let enteredWord):
            let setDuplicatedMutation = wordUseCase.isWordDuplicated(enteredWord)
                .asObservable()
                .map { [weak self] isWordDuplicated in
                    if isWordDuplicated && (enteredWord != self?.originWord) { // 원래 단어와 달라야 중복이므로
                        return Mutation.setDuplicated(true)
                    } else {
                        return Mutation.setDuplicated(false)
                    }
                }

            self.currentState.word.word = enteredWord

            return .merge([
                .just(.updateWord(self.currentState.word)),
                setDuplicatedMutation,
                .just(.setEmpty(enteredWord.isEmpty)),
            ])

        case .changeMemorizedState(let state):
            self.currentState.word.memorizedState = state

            return .merge([
                .just(.markAsEditing),
                .just(.updateWord(self.currentState.word)),
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .updateWord(let word):
            state.word = word
        case .markAsEditing:
            state.hasChanges = true
        case .setDuplicated(let enteredWordIsDuplicated):
            state.enteredWordIsDuplicated = enteredWordIsDuplicated
        case .setEmpty(let enteredWordIsEmpty):
            state.enteredWordIsEmpty = enteredWordIsEmpty
        }

        return state
    }

}

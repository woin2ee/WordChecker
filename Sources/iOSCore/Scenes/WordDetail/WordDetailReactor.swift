//
//  WordDetailReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/09.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import ReactorKit

public final class WordDetailReactor: Reactor {

    public enum Action {
        case viewDidLoad
        case beginEditing
        case doneEditing
        case editWord(String)
        case changeMemorizedState(MemorizedState)
    }

    public enum Mutation {
        case updateWord(Word)
        case markAsEditing
    }

    public struct State {
        var word: Word
        var hasChanges: Bool
    }

    public var initialState: State = State(word: .empty, hasChanges: false)

    /// 현재 보여지고 있는 단어의 UUID 입니다.
    let uuid: UUID

    /// 편집되기 전 원래 단어입니다. viewDidLoad 가 호출될 때 초기화됩니다.
    private(set) var originWord: String?

    let globalAction: GlobalAction
    let wordUseCase: WordRxUseCaseProtocol

    public init(
        uuid: UUID,
        globalAction: GlobalAction,
        wordUseCase: WordRxUseCaseProtocol
    ) {
        self.uuid = uuid
        self.globalAction = globalAction
        self.wordUseCase = wordUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
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

        case .editWord(let word):
            self.currentState.word.word = word

            return .just(.updateWord(self.currentState.word))

        case .changeMemorizedState(let state):
            self.currentState.word.memorizedState = state

            return .merge([
                .just(.markAsEditing),
                .just(.updateWord(self.currentState.word)),
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .updateWord(let word):
            state.word = word
        case .markAsEditing:
            state.hasChanges = true
        }

        return state
    }

}

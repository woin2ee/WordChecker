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

protocol WordDetailReactorDelegate: AnyObject {

    func wordDetailReactorDidUpdateWord(with uuid: UUID)

}

final class WordDetailReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case doneEditing
        case editWord(String)
        case changeMemorizedState(MemorizedState)
    }
    
    enum Mutation {
        case updateWord(Word)
        case markAsChanged
    }
    
    struct State {
        var word: Word
        var hasChanged: Bool
    }
    
    var initialState: State = State(word: .empty, hasChanged: false)
    let uuid: UUID
    
    let globalAction: GlobalAction
    let wordUseCase: WordRxUseCaseProtocol
    weak var delegate: WordDetailReactorDelegate?
    
    init(
        uuid: UUID,
        globalAction: GlobalAction,
        wordUseCase: WordRxUseCaseProtocol,
        delegate: WordDetailReactorDelegate? = nil
    ) {
        self.uuid = uuid
        self.globalAction = globalAction
        self.wordUseCase = wordUseCase
        self.delegate = delegate
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return wordUseCase.getWord(by: uuid)
                .asObservable()
                .map(Mutation.updateWord)
            
        case .doneEditing:
            return wordUseCase.updateWord(by: uuid, to: self.currentState.word)
                .doOnSuccess { _ in
                    self.delegate?.wordDetailReactorDidUpdateWord(with: self.uuid)
                    GlobalAction.shared.didEditWord.accept(self.currentState.word)
                }
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in return .empty() }
            
        case .editWord(let word):
            self.currentState.word.word = word
            
            return .merge([
                .just(.markAsChanged),
                .just(.updateWord(self.currentState.word)),
            ])
            
        case .changeMemorizedState(let state):
            self.currentState.word.memorizedState = state
            
            return .merge([
                .just(.markAsChanged),
                .just(.updateWord(self.currentState.word)),
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateWord(let word):
            state.word = word
        case .markAsChanged:
            state.hasChanged = true
        }
        
        return state
    }
    
}

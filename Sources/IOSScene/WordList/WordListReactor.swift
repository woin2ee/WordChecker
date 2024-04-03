//
//  WordListReactor.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/10.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Word
import Foundation
import IOSSupport
import ReactorKit
import UseCase_Word

final class WordListReactor: Reactor {

    enum Action {
        case viewDidLoad
        case deleteWord(IndexPath.Index)
        case editWord(String, IndexPath.Index)
        case refreshWordList(ListType)
        case refreshWordListByCurrentType
    }

    enum Mutation {
        case changeListType(ListType)
        case updateWordList([Word])
    }

    struct State {
        var listType: ListType
        var wordList: [Word]
    }

    var initialState: State = State(listType: .all, wordList: [])

    let globalAction: GlobalAction
    let wordUseCase: WordUseCase

    init(globalAction: GlobalAction, wordUseCase: WordUseCase) {
        self.globalAction = globalAction
        self.wordUseCase = wordUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateWordList(by: self.currentState.listType)

        case .deleteWord(let index):
            let target = self.currentState.wordList[index]

            return wordUseCase.deleteWord(by: target.uuid).asObservable()
                .doOnNext { self.globalAction.didDeleteWord.accept(target) }
                .flatMap { self.updateWordList(by: self.currentState.listType) }

        case .editWord(let word, let index):
            let target = self.currentState.wordList[index]

            return wordUseCase.updateWord(by: target.uuid, with: WordAttribute(word: word))
                .asObservable()
                .doOnNext { self.globalAction.didEditWord.accept(target.uuid) }
                .flatMap { self.updateWordList(by: self.currentState.listType) }

        case .refreshWordList(let listType):
            return .merge([
                .just(.changeListType(listType)),
                updateWordList(by: listType),
            ])

        case .refreshWordListByCurrentType:
            return updateWordList(by: self.currentState.listType)
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge([
            mutation,
            globalAction.didEditWord
                .flatMap { _ in self.updateWordList(by: self.currentState.listType) },
            globalAction.didAddWord
                .flatMap { _ in self.updateWordList(by: self.currentState.listType) },
        ])
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .changeListType(let listType):
            state.listType = listType
        case .updateWordList(let wordList):
            state.wordList = wordList
        }

        return state
    }

    /// 전달된 ListType 에 따라 단어 리스트를 가져와서 업데이트하는 Mutation 을 방출합니다.
    ///
    /// 이 함수는 ListType 상태를 직접 업데이트 하지 않습니다.
    private func updateWordList(by listType: ListType) -> Observable<Mutation> {
        let wordList: [Word]

        switch listType {
        case .all:
            wordList = wordUseCase.fetchWordList()
        case .memorized:
            wordList = wordUseCase.fetchMemorizedWordList()
        case .unmemorized:
            wordList = wordUseCase.fetchUnmemorizedWordList()
        }

        return .just(Mutation.updateWordList(wordList))
    }

}

// MARK: - ListType

extension WordListReactor {

    enum ListType {

        case all

        case memorized

        case unmemorized

    }

}

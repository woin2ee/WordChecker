//
//  AppState.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import ReSwift

// MARK: - State

public struct AppState: StateType {

    public var wordState: WordState

}

// MARK: - Reducer

extension AppState {

    public struct Reducer: ReducerType {

        let wordStateReducer: WordState.Reducer

        public init(wordStateReducer: WordState.Reducer) {
            self.wordStateReducer = wordStateReducer
        }

        public func createNewState(action: Action, state: AppState?) -> AppState {
            var state: AppState = state ?? .init(wordState: wordStateReducer.createNewState(action: action, state: state?.wordState))

            switch action {
            case let action as WordState.Actions:
                state.wordState = wordStateReducer.createNewState(action: action, state: state.wordState)
            default:
                break
            }

            return state
        }

    }

}

// MARK: - Actions

extension AppState {

    public enum Actions: Action {}

}

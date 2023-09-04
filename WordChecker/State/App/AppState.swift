//
//  AppState.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift

struct AppState {

    // MARK: - State

    var wordState: WordState

}

extension AppState: State {

    static func reducer(action: Action, state: Self?) -> Self {
        var state: AppState = state ?? .initialState(action: action, state: state)

        switch action {
        case let action as WordStateAction:
            state.wordState = .reducer(action: action, state: state.wordState)
        default:
            break
        }

        return state
    }

    static func initialState(action: Action, state: Self?) -> Self {
        return .init(wordState: WordState.reducer(action: action, state: state?.wordState))
    }

}

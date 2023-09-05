//
//  AppStateReducer.swift
//  StateStore
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Foundation
import ReSwift

public struct AppStateReducer: ReducerType {

    let wordStateReducer: WordStateReducer

    public init(wordStateReducer: WordStateReducer) {
        self.wordStateReducer = wordStateReducer
    }

    public func createNewState(action: Action, state: AppState?) -> AppState {
        var state: AppState = state ?? .init(wordState: wordStateReducer.createNewState(action: action, state: state?.wordState))

        switch action {
        case let action as WordStateAction:
            state.wordState = wordStateReducer.createNewState(action: action, state: state.wordState)
        default:
            break
        }

        return state
    }

}

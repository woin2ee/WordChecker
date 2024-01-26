//
//  GeneralSettingsReactor.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import ReactorKit

final class GeneralSettingsReactor: Reactor {

    enum Action {
        case hapticsSwitchIsOn(Bool)
    }

    enum Mutation {
        case onHaptics
        case offHaptics
    }

    struct State {
        var hapticsIsOn: Bool
    }

    var initialState: State = .init(hapticsIsOn: false)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .hapticsSwitchIsOn(let hapticsSwitchIsOn):
            return hapticsSwitchIsOn ? .just(.onHaptics) : .just(.offHaptics)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .onHaptics:
            state.hapticsIsOn = true
        case .offHaptics:
            state.hapticsIsOn = false
        }

        return state
    }

}

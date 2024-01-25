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

    }

    enum Mutation {

    }

    struct State {

    }

    var initialState: State = .init()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {

        }

        return state
    }

}

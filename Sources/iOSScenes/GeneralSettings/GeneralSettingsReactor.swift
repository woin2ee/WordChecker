//
//  GeneralSettingsReactor.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain
import IOSSupport
import ReactorKit

final class GeneralSettingsReactor: Reactor {

    enum Action {
        case viewDidLoad
        case tapHapticsSwitch
    }

    enum Mutation {
        case onHaptics
        case offHaptics
    }

    struct State {
        var hapticsIsOn: Bool
    }

    var initialState: State = .init(hapticsIsOn: true)

    let userSettingsUseCase: UserSettingsUseCaseProtocol
    let globalState: GlobalState

    init(userSettingsUseCase: UserSettingsUseCaseProtocol, globalState: GlobalState) {
        self.userSettingsUseCase = userSettingsUseCase
        self.globalState = globalState
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userSettingsUseCase.getCurrentUserSettings()
                .asObservable()
                .map(\.hapticsIsOn)
                .map { $0 ? Mutation.onHaptics : Mutation.offHaptics }

        case .tapHapticsSwitch:
            if self.currentState.hapticsIsOn {
                return userSettingsUseCase.offHaptics()
                    .asObservable()
                    .doOnNext { self.globalState.hapticsIsOn = false }
                    .map { Mutation.offHaptics }
            } else {
                return userSettingsUseCase.onHaptics()
                    .asObservable()
                    .doOnNext { self.globalState.hapticsIsOn = true }
                    .map { Mutation.onHaptics }
            }
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

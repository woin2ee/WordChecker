//
//  GeneralSettingsReactor.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import ReactorKit
import UseCase_UserSettings

final class GeneralSettingsReactor: Reactor {

    enum Action {
        case viewDidLoad
        case tapHapticsSwitch
        case tapAutoCapitalizationSwitch
    }

    enum Mutation {
        case onHaptics
        case offHaptics
        case onAutoCapitalization
        case offAutoCapitalization
    }

    struct State {
        var hapticsIsOn: Bool
        var autoCapitalizationIsOn: Bool
    }

    var initialState = State(
        hapticsIsOn: true,
        autoCapitalizationIsOn: true
    )

    let userSettingsUseCase: UserSettingsUseCase
    let globalState: GlobalState

    init(userSettingsUseCase: UserSettingsUseCase, globalState: GlobalState) {
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
            
        case .tapAutoCapitalizationSwitch:
            if self.currentState.autoCapitalizationIsOn {
                return userSettingsUseCase.offAutoCapitalization()
                    .asObservable()
                    .doOnNext { self.globalState.autoCapitalizationIsOn = false }
                    .map { Mutation.offAutoCapitalization }
            } else {
                return userSettingsUseCase.onAutoCapitalization()
                    .asObservable()
                    .doOnNext { self.globalState.autoCapitalizationIsOn = true }
                    .map { Mutation.onAutoCapitalization }
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
        case .onAutoCapitalization:
            state.autoCapitalizationIsOn = true
        case .offAutoCapitalization:
            state.autoCapitalizationIsOn = false
        }

        return state
    }

}

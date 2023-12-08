//
//  PushNotificationSettingsReactor.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import ReactorKit

public final class PushNotificationSettingsReactor: Reactor {

    public enum Action {
        case viewDidLoad
        case onDailyReminder
        case offDailyReminder
        case changeReminderTime(Date)
    }

    public enum Mutation {
        case enableDailyReminder
        case disableDailyReminder
        case setReminderTime(DateComponents)
    }

    public struct State {
        var isOnDailyReminder: Bool
        var reminderTime: DateComponents
    }

    public let initialState: State = .init(
        isOnDailyReminder: false,
        reminderTime: .init(hour: 9, minute: 0)
    )

    let userSettingsUseCase: UserSettingsUseCaseProtocol

    init(userSettingsUseCase: UserSettingsUseCaseProtocol) {
        self.userSettingsUseCase = userSettingsUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let latestTime = try? userSettingsUseCase.getLatestDailyReminderTime()

            let setReminderTimeSequence: Observable<Mutation> = latestTime != nil
            ? .just(.setReminderTime(latestTime!))
            : .empty()

            let getDailyReminderSequence = userSettingsUseCase.getDailyReminder()
                .asObservable()
                .catch { _ in return .empty() }
                .map { _ in Mutation.enableDailyReminder }

            return .merge([
                getDailyReminderSequence,
                setReminderTimeSequence,
            ])

        case .onDailyReminder:
            return userSettingsUseCase.setDailyReminder(at: self.currentState.reminderTime)
                .asObservable()
                .map { Mutation.enableDailyReminder }

        case .offDailyReminder:
            userSettingsUseCase.removeDailyReminder()
            return .just(.disableDailyReminder)

        case .changeReminderTime(let date):
            let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: date)

            guard let hour = hourAndMinute.hour, let minute = hourAndMinute.minute else {
                preconditionFailure("Not included [hour, minute] component in Date.")
            }

            return .just(.setReminderTime(.init(hour: hour, minute: minute)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .enableDailyReminder:
            state.isOnDailyReminder = true
        case .disableDailyReminder:
            state.isOnDailyReminder = false
        case .setReminderTime(let dateComponents):
            state.reminderTime = dateComponents
        }

        return state
    }

}

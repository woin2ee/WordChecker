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
        case reactorNeedsUpdate
        case tapDailyReminderSwitch
        case changeReminderTime(Date)
    }

    public enum Mutation {
        case enableDailyReminder
        case disableDailyReminder
        case setReminderTime(DateComponents)
        case showNeedAuthAlert
        case showMoveToAuthSettingAlert
    }

    public struct State {
        var isOnDailyReminder: Bool
        var reminderTime: DateComponents
        @Pulse var needAuthAlert: Void?
        @Pulse var moveToAuthSettingAlert: Void?
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
        case .reactorNeedsUpdate:
            let latestTime = try? userSettingsUseCase.getLatestDailyReminderTime()

            let setReminderTimeSequence: Observable<Mutation> = latestTime != nil
            ? .just(.setReminderTime(latestTime!))
            : .empty()

            let enableDailyReminderSequence = userSettingsUseCase.getDailyReminder()
                .asObservable()
                .catch { _ in return .empty() }
                .map { _ in Mutation.enableDailyReminder }

            return .merge([
                enableDailyReminderSequence,
                setReminderTimeSequence,
            ])

        case .tapDailyReminderSwitch:
            /// 현재 `DailyReminder` 가 ON 상태이면 OFF 로, OFF 상태이면 ON 으로 변경하는 `Mutation` 을 반환합니다.
            func toggleDailyReminder() -> Mutation {
                if currentState.isOnDailyReminder {
                    return .disableDailyReminder
                } else {
                    return .enableDailyReminder
                }
            }

            return userSettingsUseCase.getNotificationAuthorizationStatus()
                .asObservable()
                .flatMap { status -> Observable<Mutation> in
                    switch status {
                    case .notDetermined:
                        return self.userSettingsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
                            .asObservable()
                            .flatMap { hasAuthorization -> Observable<Mutation> in
                                if hasAuthorization {
                                    return .just(toggleDailyReminder())
                                } else {
                                    return .merge([
                                        .just(.disableDailyReminder),
                                        .just(.showNeedAuthAlert),
                                    ])
                                }
                            }
                    case .authorized:
                        return .just(toggleDailyReminder())
                    default:
                        return .merge([
                            .just(.disableDailyReminder),
                            .just(.showMoveToAuthSettingAlert),
                        ])
                    }
                }

        case .changeReminderTime(let date):
            let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: date)
            return .just(.setReminderTime(hourAndMinute))
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
        case .showNeedAuthAlert:
            state.needAuthAlert = ()
        case .showMoveToAuthSettingAlert:
            state.moveToAuthSettingAlert = ()
        }

        return state
    }

}

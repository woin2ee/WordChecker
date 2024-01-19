//
//  PushNotificationSettingsReactor.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import iOSSupport
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
    let globalAction: GlobalAction

    init(userSettingsUseCase: UserSettingsUseCaseProtocol, globalAction: GlobalAction) {
        self.userSettingsUseCase = userSettingsUseCase
        self.globalAction = globalAction
    }

    public func transform(action: Observable<Action>) -> Observable<Action> {
        return .merge([
            action,
            globalAction.sceneWillEnterForeground
                .map { Action.reactorNeedsUpdate },
        ])
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reactorNeedsUpdate:
            let latestTime = try? userSettingsUseCase.getLatestDailyReminderTime()

            let setReminderTimeSequence: Observable<Mutation> = latestTime != nil
            ? .just(.setReminderTime(latestTime!))
            : .empty()

            let setDailyReminderSequence = userSettingsUseCase.getDailyReminder()
                .asObservable()
                .map { _ in Mutation.enableDailyReminder }
                .catch { _ in self.removeDailyReminder() }

            return .merge([
                setDailyReminderSequence,
                setReminderTimeSequence,
            ])

        case .tapDailyReminderSwitch:
            return userSettingsUseCase.getNotificationAuthorizationStatus()
                .asObservable()
                .flatMap { status -> Observable<Mutation> in
                    switch status {
                    case .notDetermined: // 권한이 결정되어 있지 않은 경우(대부분 첫 알림 설정)
                        return self.userSettingsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
                            .asObservable()
                            .flatMap { hasAuthorization -> Observable<Mutation> in
                                if hasAuthorization {
                                    return self.toggleDailyReminder()
                                } else {
                                    return .merge([
                                        self.removeDailyReminder(),
                                        .just(.showNeedAuthAlert),
                                    ])
                                }
                            }
                    case .authorized: // 알림 권한 승인
                        return self.toggleDailyReminder()
                    default: // 알림 권한 거부
                        return .merge([
                            self.removeDailyReminder(),
                            .just(.showMoveToAuthSettingAlert),
                        ])
                    }
                }

        case .changeReminderTime(let date):
            let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: date)
            return userSettingsUseCase.setDailyReminder(at: hourAndMinute)
                .asObservable()
                .map { Mutation.setReminderTime(hourAndMinute) }
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

// MARK: - Helpers

extension PushNotificationSettingsReactor {

    /// 매일 알림을 설정하고 `Mutation Sequence` 를 반환합니다.
    func setDailyReminder() -> Observable<Mutation> {
        return userSettingsUseCase.setDailyReminder(at: self.currentState.reminderTime)
            .asObservable()
            .map { Mutation.enableDailyReminder }
            .catchAndReturn(.disableDailyReminder)
    }

    /// 매일 알림을 삭제하고 `Mutation Sequence` 를 반환합니다.
    func removeDailyReminder() -> Observable<Mutation> {
        userSettingsUseCase.removeDailyReminder()
        return .just(.disableDailyReminder)
    }

    /// 현재 설정되어 있는 매일 알림이 없으면 설정하고, 설정되어 있는 매일 알림이 있으면 삭제합니다.
    func toggleDailyReminder() -> Observable<Mutation> {
        if currentState.isOnDailyReminder {
            return removeDailyReminder()
        } else {
            return setDailyReminder()
        }
    }

}

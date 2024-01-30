//
//  HapticGenerator.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 1/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

public final class HapticGenerator {

    public static let shared: HapticGenerator = .init()

    let globalState: GlobalState = .shared

    private var feedbackGenerator: UIFeedbackGenerator?

    /// 준비되어 있는 UIFeedbackGenerator 가 UIImpactFeedbackGenerator 일때, 해당 UIImpactFeedbackGenerator 의 style 입니다.
    private var preparedImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle?

    private init() {}

    /// Prepares the generator to trigger feedback.
    public func impactPrepare(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard globalState.hapticsIsOn else {
            return
        }

        preparedImpactStyle = style
        if !equalToPreparedImpactFeedbackGenerator(style: style) {
            feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        }

        feedbackGenerator?.prepare()
    }

    /// Triggers impact feedback with a specific style and specific intensity.
    public func impactOccurred(style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat = 1.0) {
        guard globalState.hapticsIsOn else {
            return
        }

        defer {
            preparedImpactStyle = nil
            feedbackGenerator = nil
        }

        if !equalToPreparedImpactFeedbackGenerator(style: style) {
            feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        }

        (feedbackGenerator as? UIImpactFeedbackGenerator)?.impactOccurred(intensity: intensity)
    }

    /// Triggers impact feedback with a specific style and specific intensity, and then keep preparing.
    public func impactOccurredKeepPreparing(style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat = 1.0) {
        guard globalState.hapticsIsOn else {
            return
        }

        if !equalToPreparedImpactFeedbackGenerator(style: style) {
            preparedImpactStyle = style
            feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        }

        (feedbackGenerator as? UIImpactFeedbackGenerator)?.impactOccurred(intensity: intensity)

        feedbackGenerator?.prepare()
    }

    public func selectionPrepare() {
        guard globalState.hapticsIsOn else {
            return
        }

        if !(feedbackGenerator is UISelectionFeedbackGenerator) {
            feedbackGenerator = UISelectionFeedbackGenerator()
        }

        feedbackGenerator?.prepare()
    }

    public func selectionChanged() {
        guard globalState.hapticsIsOn else {
            return
        }

        defer {
            feedbackGenerator = nil
        }

        if !(feedbackGenerator is UISelectionFeedbackGenerator) {
            feedbackGenerator = UISelectionFeedbackGenerator()
        }

        (feedbackGenerator as? UISelectionFeedbackGenerator)?.selectionChanged()
    }

    public func selectionChangedKeepPreparing() {
        guard globalState.hapticsIsOn else {
            return
        }

        if !(feedbackGenerator is UISelectionFeedbackGenerator) {
            feedbackGenerator = UISelectionFeedbackGenerator()
        }

        (feedbackGenerator as? UISelectionFeedbackGenerator)?.selectionChanged()

        feedbackGenerator?.prepare()
    }

    public func notificationPrepare() {
        guard globalState.hapticsIsOn else {
            return
        }

        if !(feedbackGenerator is UINotificationFeedbackGenerator) {
            feedbackGenerator = UINotificationFeedbackGenerator()
        }

        feedbackGenerator?.prepare()
    }

    public func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        guard globalState.hapticsIsOn else {
            return
        }

        defer {
            feedbackGenerator = nil
        }

        if !(feedbackGenerator is UINotificationFeedbackGenerator) {
            feedbackGenerator = UINotificationFeedbackGenerator()
        }

        (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(notificationType)
    }

    public func notificationOccurredKeepPreparing(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        guard globalState.hapticsIsOn else {
            return
        }

        if !(feedbackGenerator is UINotificationFeedbackGenerator) {
            feedbackGenerator = UINotificationFeedbackGenerator()
        }

        (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(notificationType)

        feedbackGenerator?.prepare()
    }

    /// 준비되어 있는 `UIImpactFeedbackGenerator` 의 style 과 매개변수로 전달된 style 이 같은지 확인합니다.
    /// - Returns: style 이 같으면 true 를 반환합니다. 만약 준비된 `UIImpactFeedbackGenerator` 가 없거나, style 이 다르면 false 를 반환합니다.
    func equalToPreparedImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) -> Bool {
        return feedbackGenerator is UIImpactFeedbackGenerator && preparedImpactStyle == style
    }

}

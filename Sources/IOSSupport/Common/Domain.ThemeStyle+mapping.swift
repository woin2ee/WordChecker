//
//  Domain.ThemeStyle+mapping.swift
//  iOSSupport
//
//  Created by Jaewon Yun on 2/7/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain
import UIKit

extension Domain.ThemeStyle {

    public func toUIKit() -> UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

}

extension UIUserInterfaceStyle {

    public func toDomain() -> Domain.ThemeStyle {
        switch self {
        case .unspecified:
            return .system
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            assertionFailure("unkown cases.")
            return .system
        }
    }

}

//
//  UIDevice+allowedIdiom.swift
//  IOSSupport
//
//  Created by Jaewon Yun on 4/15/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

extension UIDevice {

    public var allowedIdiom: AllowedIdiom {
        switch self.userInterfaceIdiom {
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            fatalError("Current idiom is not allowed.")
        }
    }
}

public enum AllowedIdiom {
    case iPhone
    case iPad
}

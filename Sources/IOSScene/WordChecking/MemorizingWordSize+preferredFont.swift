//
//  MemorizingWordSize+preferredFont.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 4/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import IOSSupport
import UIKit

extension MemorizingWordSize {
    
    var preferredFont: UIFont {
        switch UIDevice.current.allowedIdiom {

        case .iPhone:
            switch self {
            case .small:
                UIFont.preferredFont(ofSize: 18)
            case .default:
                UIFont.preferredFont(ofSize: 21)
            case .large:
                UIFont.preferredFont(ofSize: 24)
            case .veryLarge:
                UIFont.preferredFont(ofSize: 27)
            }
            
        case .iPad:
            switch self {
            case .small:
                UIFont.preferredFont(ofSize: 25)
            case .default:
                UIFont.preferredFont(ofSize: 28)
            case .large:
                UIFont.preferredFont(ofSize: 31)
            case .veryLarge:
                UIFont.preferredFont(ofSize: 34)
            }
        }
    }
}

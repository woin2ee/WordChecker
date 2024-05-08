//
//  MemorizingWordSize+preferredFont.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 4/26/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import UIKit

extension MemorizingWordSize {
    
    var preferredFont: UIFont {
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
    }
}

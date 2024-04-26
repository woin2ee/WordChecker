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
            UIFont.preferredFont(forTextStyle: .title3)
        case .default:
            UIFont.preferredFont(forTextStyle: .title2)
        case .large:
            UIFont.preferredFont(forTextStyle: .title1)
        case .veryLarge:
            UIFont.preferredFont(forTextStyle: .largeTitle)
        }
    }
}

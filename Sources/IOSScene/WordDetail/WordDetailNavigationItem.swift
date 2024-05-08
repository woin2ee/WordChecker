//
//  WordDetailNavigationItem.swift
//  IOSScene_WordDetail
//
//  Created by Jaewon Yun on 4/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Then
import UIKit

final class WordDetailNavigationItem: UINavigationItem {
    
    let doneBarButton: UIBarButtonItem = .init(title: LocalizedString.done).then {
        $0.style = .done
    }

    let cancelBarButton: UIBarButtonItem = .init(systemItem: .cancel)
    
    init() {
        super.init(title: LocalizedString.details)
        
        self.rightBarButtonItem = doneBarButton
        self.leftBarButtonItem = cancelBarButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

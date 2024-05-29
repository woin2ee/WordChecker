//
//  MemorizingProgressBar.swift
//  IOSScene_WordChecking
//
//  Created by Jaewon Yun on 5/22/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import PinLayout
import RxCocoa
import RxSwift
import Then
import UIKit
import UIKitPlus

final class MemorizingProgressBar: RoundedProgressView {
    
    private let checkedCountLabel: UILabel
    
    init() {
        checkedCountLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = .systemBackground
            $0.text = "0/0"
            $0.textColor = .white
        }
        
        super.init()
        
        self.addSubview(checkedCountLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkedCountLabel.pin.vCenter().start(30).width(120).sizeToFit(.width)
    }
    
    var memorizingCountBinder: Binder<MemorizingCount> {
        return .init(checkedCountLabel) { target, count in
            target.text = "\(count.checked)/\(count.total)"
            
            self.max = count.total
            self.progress = count.checked
        }
    }
}

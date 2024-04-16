//
//  BaseViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/09.
//

import UIKit

public protocol DeallocChecking {
    
    /// Dealloc checking 활성화 여부
    ///
    /// Configuration 이 `DEBUG` 일 때는 기본값이 `true`, `RELEASE` 일 때는 기본값이 `flase` 입니다.
    var isDeallocCheckEnabled: Bool { get set }
}

open class BaseViewController: UIViewController, DeallocChecking {

    #if DEBUG
    public var isDeallocCheckEnabled: Bool = true
    #elseif RELEASE
    public var isDeallocCheckEnabled: Bool = false
    #endif
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isDeallocCheckEnabled {
            self.checkDeallocation()
        }
    }
}

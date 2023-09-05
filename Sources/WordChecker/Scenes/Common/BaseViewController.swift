//
//  BaseViewController.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import ReSwift
import StateStore
import UIKit

class BaseViewController<S: State>: UIViewController, StoreSubscriber {

    let store: StateStore

    init(store: StateStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        subscribeStore()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file):\(#line):\(#function)")
    }

    func subscribeStore() {
        fatalError("Not overridden in \(self)")
    }

    func newState(state: S) {
        fatalError("Not overridden in \(self)")
    }

}

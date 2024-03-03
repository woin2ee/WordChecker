//
//  UIPresentationController+didAttemptToDismiss.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftSugar

extension Reactive where Base: UIPresentationController {

    var delegateProxy: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate> {
        return UIPresentationControllerDelegateProxy.proxy(for: self.base)
    }

    public var didAttemptToDismiss: Observable<Void> {
        let selector: Selector = #selector(UIAdaptivePresentationControllerDelegate.presentationControllerDidAttemptToDismiss(_:))

        return delegateProxy
            .methodInvoked(selector)
            .mapToVoid()
    }

}

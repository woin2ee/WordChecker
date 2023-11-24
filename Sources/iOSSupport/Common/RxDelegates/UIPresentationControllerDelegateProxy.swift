//
//  UIPresentationControllerDelegateProxy.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/11.
//

import RxSwift
import RxCocoa
import UIKit

final class UIPresentationControllerDelegateProxy:
    DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate>,
    DelegateProxyType,
    UIAdaptivePresentationControllerDelegate {

    static func registerKnownImplementations() {
        self.register { parent in
            return .init(parentObject: parent, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: UIPresentationController) -> UIAdaptivePresentationControllerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: UIAdaptivePresentationControllerDelegate?, to object: UIPresentationController) {
        object.delegate = delegate
    }

}

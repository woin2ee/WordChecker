//
//  GeneralSettingsViewController.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import iOSSupport
import ReactorKit
import UIKit

public protocol GeneralSettingsViewControllerDelegate: AnyObject {

}

public protocol GeneralSettingsViewControllerProtocol: UIViewController {
    var delegate: GeneralSettingsViewControllerDelegate? { get set }
}

final class GeneralSettingsViewController: RxBaseViewController, View, GeneralSettingsViewControllerProtocol {

    weak var delegate: GeneralSettingsViewControllerDelegate?

    func bind(reactor: GeneralSettingsReactor) {

    }

}

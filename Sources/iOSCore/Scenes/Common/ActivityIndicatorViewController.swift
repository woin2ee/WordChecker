//
//  ActivityIndicatorViewController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/05.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import SnapKit
import Then
import UIKit

final class ActivityIndicatorViewController: UIViewController {

    static let shared: ActivityIndicatorViewController = .init()

    let activityIndicatorView: UIActivityIndicatorView = .init(style: .large)

    private init() {
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColorByInterfaceStyle()

        self.view.addSubview(activityIndicatorView)

        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setBackgroundColorByInterfaceStyle()
    }

    private func setBackgroundColorByInterfaceStyle() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            self.view.backgroundColor = .init(white: 0.0, alpha: 0.2)
        case .dark:
            self.view.backgroundColor = .init(white: 0.0, alpha: 0.4)
        case .unspecified:
            self.view.backgroundColor = .init(white: 0.0, alpha: 0.2)
        @unknown default:
            self.view.backgroundColor = .init(white: 0.0, alpha: 0.2)
        }
    }

    func startAnimating(on viewController: UIViewController) {
        viewController.present(self, animated: false)
        activityIndicatorView.startAnimating()
    }

    func stopAnimating(on viewController: UIViewController) {
        viewController.dismiss(animated: false)
        activityIndicatorView.stopAnimating()
    }

}

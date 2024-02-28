//
//  GeneralSettingsViewController.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import ReactorKit
import RxSwiftSugar
import Then
import UIKit
import UIKitPlus

public protocol GeneralSettingsViewControllerDelegate: AnyObject, ViewControllerDelegate {
    func didTapThemeSetting()
}

public protocol GeneralSettingsViewControllerProtocol: UIViewController {
    var delegate: GeneralSettingsViewControllerDelegate? { get set }
}

final class GeneralSettingsViewController: RxBaseViewController, View, GeneralSettingsViewControllerProtocol {

    enum SectionIdentifier: Int {
        case hapticsSettings = 0
        case themeSetting
    }

    enum ItemIdentifier {
        case hapticsOnOffSwitch
        case themeSetting
    }

    weak var delegate: GeneralSettingsViewControllerDelegate?

    lazy var rootView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.register(ManualSwitchCell.self)
        $0.register(DisclosureIndicatorCell.self)
        $0.register(TextFooterView.self)
        $0.delegate = self
    }

    lazy var dataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> = .init(tableView: rootView) { [weak self] tableView, indexPath, item -> UITableViewCell? in
        guard let self = self else { return nil }
        guard let reactor = self.reactor else {
            preconditionFailure("Not assigned reactor of \(self).")
        }

        switch item {
        case .hapticsOnOffSwitch:
            let cell = tableView.dequeueReusableCell(ManualSwitchCell.self, for: indexPath)
            cell.prepareForReuse()
            cell.bind(model: .init(title: LocalizedString.haptics, isOn: reactor.currentState.hapticsIsOn))
            // Bind to Reactor.Action
            cell.wrappingButton.rx.tap
                .doOnNext {
                    if !reactor.currentState.hapticsIsOn {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred() // forced occur
                    }
                }
                .map { Reactor.Action.tapHapticsSwitch }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell

        case .themeSetting:
            let cell = tableView.dequeueReusableCell(DisclosureIndicatorCell.self, for: indexPath)
            cell.bind(model: .init(title: LocalizedString.theme))
            return cell
        }
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGroupedBackground

        self.navigationItem.title = LocalizedString.general
        self.navigationItem.largeTitleDisplayMode = .never

        applyInitialSnapshot()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isMovingFromParent {
            delegate?.viewControllerDidPop(self)
        }
    }

    func applyInitialSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([
            .hapticsSettings,
            .themeSetting,
        ])
        snapshot.appendItems([.hapticsOnOffSwitch], toSection: .hapticsSettings)
        snapshot.appendItems([.themeSetting], toSection: .themeSetting)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }

    override func bindAction() {
        let itemSelectedEvent = rootView.rx.itemSelected.asSignal()
            .doOnNext { [weak self] in self?.rootView.deselectRow(at: $0, animated: true) }

        itemSelectedEvent
            .filter { self.dataSource.itemIdentifier(for: $0) == .themeSetting }
            .emit(with: self, onNext: { owner, _ in
                owner.delegate?.didTapThemeSetting()
            })
            .disposed(by: self.disposeBag)
    }

    func bind(reactor: GeneralSettingsReactor) {
        // Action
        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.hapticsIsOn)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                guard let footerView = owner.rootView.footerView(forSection: SectionIdentifier.hapticsSettings.rawValue) as? TextFooterView else {
                    return
                }

                if reactor.currentState.hapticsIsOn {
                    footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOn
                } else {
                    footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOff
                }

                var snapshot = owner.dataSource.snapshot()
                snapshot.reconfigureItems([.hapticsOnOffSwitch])
                owner.dataSource.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
    }

}

extension GeneralSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let reactor = self.reactor else {
            preconditionFailure("Not assigned reactor of \(self).")
        }

        if section == SectionIdentifier.hapticsSettings.rawValue {
            let footerView = tableView.dequeueReusableHeaderFooterView(TextFooterView.self)
            if reactor.currentState.hapticsIsOn {
                footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOn
            } else {
                footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOff
            }
            return footerView
        }

        return nil
    }

}

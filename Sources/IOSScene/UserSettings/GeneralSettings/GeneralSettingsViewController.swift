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
        case autoCapitalizationSettings
        case themeSetting
    }

    enum ItemIdentifier {
        case hapticsOnOffSwitch
        case autoCapitalizationOnOffSwitch
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
            cell.disposeBag = DisposeBag()
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
            
        case .autoCapitalizationOnOffSwitch:
            let cell = tableView.dequeueReusableCell(ManualSwitchCell.self, for: indexPath)
            let title = String(localized: "Auto Capitalization", bundle: .module)
            let model = SwitchCell.Model(title: title, isOn: reactor.currentState.autoCapitalizationIsOn)
            cell.bind(model: model)
            cell.disposeBag = DisposeBag()
            cell.wrappingButton.rx.tap
                .doOnNext { HapticGenerator.shared.impactOccurred(style: .light) }
                .map { Reactor.Action.tapAutoCapitalizationSwitch }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
            
        case .themeSetting:
            let cell = tableView.dequeueReusableCell(DisclosureIndicatorCell.self, for: indexPath)
            cell.bind(model: .init(title: LocalizedString.theme))
            return cell
        }
    }
    
    override init() {
        super.init()
        
        let initialSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>().with {
            $0.appendSections([
                .hapticsSettings,
                .autoCapitalizationSettings,
                .themeSetting,
            ])
            $0.appendItems([.hapticsOnOffSwitch], toSection: .hapticsSettings)
            $0.appendItems([.autoCapitalizationOnOffSwitch], toSection: .autoCapitalizationSettings)
            $0.appendItems([.themeSetting], toSection: .themeSetting)
        }
        dataSource.applySnapshotUsingReloadData(initialSnapshot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGroupedBackground

        self.navigationItem.title = LocalizedString.general
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isMovingFromParent {
            delegate?.viewControllerDidPop(self)
        }
    }

    override func bindActions() {
        let itemSelectedEvent = rootView.rx.itemSelected.asSignal()
            .doOnNext { [weak self] in self?.rootView.deselectRow(at: $0, animated: true) }

        itemSelectedEvent
            .filter { [weak self] in self?.dataSource.itemIdentifier(for: $0) == .themeSetting }
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
            .drive(with: self) { owner, hapticsIsOn in
                var snapshot = owner.dataSource.snapshot()
                snapshot.reconfigureItems([.hapticsOnOffSwitch])
                owner.dataSource.apply(snapshot)
                
                if let footerView = owner.rootView.footerView(forSection: SectionIdentifier.hapticsSettings.rawValue) as? TextFooterView {
                    owner.setHapticsSettingsFooterText(in: footerView, hapticsIsOn)
                }
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map(\.autoCapitalizationIsOn)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, autoCapitalizationIsOn in
                var snapshot = owner.dataSource.snapshot()
                snapshot.reconfigureItems([.autoCapitalizationOnOffSwitch])
                owner.dataSource.apply(snapshot)
                
                if let footerView = owner.rootView.footerView(forSection: SectionIdentifier.autoCapitalizationSettings.rawValue) as? TextFooterView {
                    owner.setAutoCapitalizationSettingsFooterText(in: footerView, autoCapitalizationIsOn)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setHapticsSettingsFooterText(in footerView: TextFooterView, _ hapticsIsOn: Bool) {
        if hapticsIsOn {
            footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOn
        } else {
            footerView.text = LocalizedString.hapticsSettingsFooterTextWhenHapticsIsOff
        }
    }
    
    private func setAutoCapitalizationSettingsFooterText(
        in footerView: TextFooterView,
        _ autoCapitalizationIsOn: Bool
    ) {
        if autoCapitalizationIsOn {
            footerView.text = String(localized: "When you add a word, it automatically capitalizes the first letter.", bundle: .module)
        } else {
            footerView.text = ""
        }
    }
}

extension GeneralSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let reactor = self.reactor else {
            preconditionFailure("Not assigned reactor of \(self).")
        }

        if section == SectionIdentifier.hapticsSettings.rawValue {
            let footerView = tableView.dequeueReusableHeaderFooterView(TextFooterView.self)
            setHapticsSettingsFooterText(in: footerView, reactor.currentState.hapticsIsOn)
            return footerView
        }
        
        if section == SectionIdentifier.autoCapitalizationSettings.rawValue {
            let footerView = tableView.dequeueReusableHeaderFooterView(TextFooterView.self)
            setAutoCapitalizationSettingsFooterText(in: footerView, reactor.currentState.autoCapitalizationIsOn)
            return footerView
        }

        return nil
    }

}

import iOSSupport
import ReactorKit
import Then
import UIKit

public protocol PushNotificationSettingsDelegate: AnyObject {
    func willPopView()
}

public protocol PushNotificationSettingsViewControllerProtocol: UIViewController {
    var delegate: PushNotificationSettingsDelegate? { get set }
}

final class PushNotificationSettingsViewController: RxBaseViewController, View, PushNotificationSettingsViewControllerProtocol {

    enum SectionIdentifier {
        case dailyReminder
    }

    enum ItemIdentifier {
        case dailyReminderSwitch
        case dailyReminderTimeSetter
    }

    lazy var rootTableView: PushNotificationSettingsView = .init(frame: .zero, style: .insetGrouped).then {
        $0.delegate = self
    }

    weak var delegate: PushNotificationSettingsDelegate?

    lazy var dataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> = .init(tableView: rootTableView) { [weak self] tableView, indexPath, itemIdentifier -> UITableViewCell? in
        guard let self = self else { return nil }
        guard let reactor = self.reactor else { return nil }

        switch itemIdentifier {
        case .dailyReminderSwitch:
            let cell = tableView.dequeueReusableCell(ManualSwitchCell.self, for: indexPath)
            cell.prepareForReuse()
            cell.bind(model: .init(title: WCString.daily_reminder, isOn: reactor.currentState.isOnDailyReminder))
            // Bind to Reactor.Action
            cell.wrappingButton.rx.tap
                .doOnNext { HapticGenerator.shared.impactOccurred(style: .light) }
                .map { _ in Reactor.Action.tapDailyReminderSwitch }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        case .dailyReminderTimeSetter:
            let cell = tableView.dequeueReusableCell(DatePickerCell.self, for: indexPath)
            cell.prepareForReuse()
            cell.trailingDatePicker.datePickerMode = .time
            cell.trailingDatePicker.minuteInterval = 5

            guard let date = Calendar.current.date(from: reactor.currentState.reminderTime) else {
                preconditionFailure("Failed to create Date instance with DateComponents.")
            }

            cell.bind(model: .init(title: WCString.time, date: date))
            // Bind to Reactor.Action
            cell.trailingDatePicker.rx.date
                .map { Reactor.Action.changeReminderTime($0) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
        .then {
            $0.defaultRowAnimation = .fade
        }

    private var isViewAppeared: Bool = false

    init() {
        super.init(nibName: nil, bundle: nil)
        initDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = rootTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGroupedBackground

        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppeared = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            delegate?.willPopView()
        }
    }

    func initDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.dailyReminder])
        snapshot.appendItems([.dailyReminderSwitch])
        dataSource.apply(snapshot)
    }

    func setupNavigationBar() {
        self.navigationItem.title = WCString.notifications
        self.navigationItem.largeTitleDisplayMode = .never
    }

    func bind(reactor: PushNotificationSettingsReactor) {
        // Action
        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.reactorNeedsUpdate }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.isOnDailyReminder)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, isOnDailyReminder in
                var snapshot = owner.dataSource.snapshot()

                /// `isViewAppeared` 프로퍼티에 따라 애니메이션 적용 여부를 판단하여 Snapshot 을 적용합니다.
                func applySnapshot() {
                    if owner.isViewAppeared {
                        owner.dataSource.apply(snapshot)
                    } else {
                        owner.dataSource.apply(snapshot, animatingDifferences: false)
                    }
                }

                if isOnDailyReminder {
                    snapshot.appendItems([.dailyReminderTimeSetter], toSection: .dailyReminder)
                } else {
                    snapshot.deleteItems([.dailyReminderTimeSetter])
                }
                applySnapshot()

                snapshot.reconfigureItems([.dailyReminderSwitch])
                applySnapshot()
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map(\.reminderTime)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, _ in
                guard owner.dataSource.indexPath(for: .dailyReminderTimeSetter) != nil else {
                    return
                }

                var snapshot = owner.dataSource.snapshot()
                snapshot.reconfigureItems([.dailyReminderTimeSetter])
                owner.dataSource.apply(snapshot)
            })
            .disposed(by: self.disposeBag)

        reactor.pulse(\.$needAuthAlert)
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.allow_notifications_is_required)
            }
            .disposed(by: self.disposeBag)

        reactor.pulse(\.$moveToAuthSettingAlert)
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, _ in
                owner.presentOKAlert(title: WCString.notice, message: WCString.allow_notifications_is_required)
            }
            .disposed(by: self.disposeBag)
    }

}

extension PushNotificationSettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return rootTableView.footerLabel
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return rootTableView.footerLabel.intrinsicContentSize.height
    }

}

import iOSSupport
import ReactorKit
import Then
import UIKit

public protocol PushNotificationSettingsDelegate: AnyObject {
    func willPopView()
}

public final class PushNotificationSettingsViewController: RxBaseViewController, View {

    enum SectionIdentifier {
        case dailyReminder
    }

    enum ItemIdentifier {
        case dailyReminderSwitch
        case dailyReminderTimeSetter
        case dailyReminderFooter
    }

    lazy var rootTableView: PushNotificationSettingsView = .init(frame: .zero, style: .insetGrouped).then {
        $0.delegate = self
    }

    let footerLabel: PaddingLabel = .init(padding: .init(top: 8, left: 20, bottom: 8, right: 20)).then {
        $0.text = "Test footer."
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
    }

    public weak var delegate: PushNotificationSettingsDelegate?

    lazy var dataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> = .init(tableView: rootTableView) { [weak self] tableView, indexPath, itemIdentifier in
        guard let self = self else { return nil }
        guard let reactor = self.reactor else { return nil }

        switch itemIdentifier {
        case .dailyReminderSwitch:
            let cell = tableView.dequeueReusableCell(SwitchCell.self, for: indexPath)
            cell.bind(model: .init(title: WCString.daily_reminder, isOn: reactor.currentState.isOnDailyReminder))
            // Bind to Reactor.Action
            cell.trailingSwitch.rx.isOn
                .map { $0 ? Reactor.Action.onDailyReminder : Reactor.Action.offDailyReminder }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        case .dailyReminderTimeSetter:
            let cell = tableView.dequeueReusableCell(DatePickerCell.self, for: indexPath)
            cell.trailingDatePicker.datePickerMode = .time

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
        case .dailyReminderFooter:
            return nil
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        initDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = rootTableView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGroupedBackground

        setupNavigationBar()
    }

    public override func viewWillDisappear(_ animated: Bool) {
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

    public func bind(reactor: PushNotificationSettingsReactor) {
        // Action
        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.isOnDailyReminder)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
            .drive(with: self, onNext: { owner, isOnDailyReminder in
                var snapshot = owner.dataSource.snapshot()

                if isOnDailyReminder {
                    snapshot.appendItems([.dailyReminderTimeSetter], toSection: .dailyReminder)
                } else {
                    snapshot.deleteItems([.dailyReminderTimeSetter])
                }

                owner.dataSource.apply(snapshot)
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
    }

}

extension PushNotificationSettingsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerLabel
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerLabel.intrinsicContentSize.height
    }

}

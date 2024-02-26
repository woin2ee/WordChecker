import FoundationPlus
import IOSSupport
import OrderedCollections
import ReactorKit
import UIKit

public protocol ThemeSettingViewControllerDelegate: AnyObject, ViewControllerDelegate {
}

public protocol ThemeSettingViewControllerProtocol: UIViewController {
    var delegate: ThemeSettingViewControllerDelegate? { get set }
}

final class ThemeSettingViewController: RxBaseViewController, View, ThemeSettingViewControllerProtocol {

    enum SectionIdentifier {
        case theme
    }

    enum ItemIdentifier: Hashable {
        case theme(UIUserInterfaceStyle)
    }

    /// `ItemIdentifier` 로 인해 구분되는 Item 들을 보여주기 위한 값을 가지고 있는 OrderedDictionary 타입 Model 입니다.
    ///
    /// `TableView` 에 보여지는 순서대로 값을 가지고 있습니다.
    lazy var itemModels: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model> = defaultItemModels

    var defaultItemModels: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model> {
        [
            ItemIdentifier.theme(.unspecified),
            ItemIdentifier.theme(.light),
            ItemIdentifier.theme(.dark),
        ]
            .reduce(into: OrderedDictionary<ItemIdentifier, CheckmarkCell.Model>()) { partialResult, itemIdentifier in
                if case let .theme(style) = itemIdentifier {
                    partialResult[itemIdentifier] = .init(title: localizedCellTitle(by: style), isChecked: false)
                }
            }
    }

    lazy var dataSource: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> = .init(tableView: rootView) { [weak self] tableView, indexPath, itemIdentifier -> UITableViewCell? in
        guard let self = self else { return nil }
        guard let itemModel = itemModels[itemIdentifier] else { return nil }

        switch itemIdentifier {
        case .theme(let style):
            let cell = tableView.dequeueReusableCell(CheckmarkCell.self, for: indexPath)
            cell.bind(model: .init(title: localizedCellTitle(by: style), isChecked: itemModel.isChecked))
            return cell
        }
    }

    weak var delegate: ThemeSettingViewControllerDelegate?

    lazy var rootView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.register(CheckmarkCell.self)
    }

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGroupedBackground
        self.navigationItem.title = LocalizedString.theme

        applyInitialSnapshotIfNoSections()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isMovingFromParent {
            delegate?.viewControllerDidPop(self)
        }
    }

    /// 현재 DataSource 에 적용된 Snapshot 이 없다면 초기 Snapshot 을 적용합니다.
    /// - Returns: 현재 DataSource 에 적용된 Snapshot 이 있다면 해당 Snapshot 을 반환, 없다면 새로 적용한 Snapshot 을 반환합니다.
    @discardableResult
    func applyInitialSnapshotIfNoSections() -> NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> {
        let currenetSnapshot = dataSource.snapshot()

        if currenetSnapshot.sectionIdentifiers.isNotEmpty {
            return currenetSnapshot
        }

        var snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> = .init()
        let itemIdentifiers = Array(itemModels.keys)

        snapshot.appendSections([.theme])
        snapshot.appendItems(itemIdentifiers, toSection: .theme)
        dataSource.applySnapshotUsingReloadData(snapshot)
        return snapshot
    }

    func bind(reactor: ThemeSettingReactor) {
        // Action
        self.rx.sentMessage(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        rootView.rx.itemSelected
            .doOnNext { [weak self] in self?.rootView.deselectRow(at: $0, animated: false) }
            .compactMap { [weak self] indexPath in
                guard case .theme(let style) = self?.dataSource.itemIdentifier(for: indexPath) else {
                    assertionFailure("Selected invalid item.")
                    return nil
                }
                return style
            }
            .map(Reactor.Action.selectStyle)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map(\.selectedStyle)
            .skip(1) // skip initialState
            .asDriverOnErrorJustComplete()
            .drive(with: self) { owner, selectedStyle in
                var snapshot = owner.dataSource.snapshot()
                snapshot = owner.applyInitialSnapshotIfNoSections()

                owner.itemModels = owner.defaultItemModels
                owner.itemModels[.theme(selectedStyle)] = .init(title: owner.localizedCellTitle(by: selectedStyle), isChecked: true)

                snapshot.reconfigureItems(snapshot.itemIdentifiers(inSection: .theme))
                owner.dataSource.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
    }

    func localizedCellTitle(by style: UIUserInterfaceStyle) -> String {
        switch style {
        case .unspecified:
            return LocalizedString.system_mode
        case .light:
            return LocalizedString.light_mode
        case .dark:
            return LocalizedString.dark_mode
        @unknown default:
            assertionFailure("unkown cases.")
            return ""
        }
    }

}

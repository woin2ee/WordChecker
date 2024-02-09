import UIKit

public class SwitchCell: RxBaseReusableCell {

    public struct Model {
        let title: String
        let isOn: Bool

        public init(title: String, isOn: Bool) {
            self.title = title
            self.isOn = isOn
        }
    }

    public let leadingLabel: UILabel = .init()
    public let trailingSwitch: UISwitch = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryView = trailingSwitch
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func bind(model: Model) {
        var config: UIListContentConfiguration = .cell()
        config.text = model.title
        self.contentConfiguration = config
        trailingSwitch.setOn(model.isOn, animated: true)
    }

}

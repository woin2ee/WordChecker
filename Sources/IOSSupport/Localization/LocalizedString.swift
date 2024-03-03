import Foundation

internal struct LocalizedString {

    private init() {}

    static let ok = NSLocalizedString("ok", bundle: Bundle.module, comment: "")
    static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    static let discardChanges = NSLocalizedString("discardChanges", bundle: Bundle.module, comment: "")
}

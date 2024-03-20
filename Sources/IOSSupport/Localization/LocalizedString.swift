import Foundation

internal struct LocalizedString {

    private init() {}

    static let ok = NSLocalizedString("ok", bundle: Bundle.module, comment: "")
    static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    static let discardChanges = NSLocalizedString("discardChanges", bundle: Bundle.module, comment: "")
    
    static let korean = NSLocalizedString("korean", bundle: Bundle.module, comment: "")
    static let english = NSLocalizedString("english", bundle: Bundle.module, comment: "")
    static let japanese = NSLocalizedString("japanese", bundle: Bundle.module, comment: "")
    static let chinese = NSLocalizedString("chinese", bundle: Bundle.module, comment: "")
    static let french = NSLocalizedString("french", bundle: Bundle.module, comment: "")
    static let spanish = NSLocalizedString("spanish", bundle: Bundle.module, comment: "")
    static let italian = NSLocalizedString("italian", bundle: Bundle.module, comment: "")
    static let german = NSLocalizedString("german", bundle: Bundle.module, comment: "")
    static let russian = NSLocalizedString("russian", bundle: Bundle.module, comment: "")
}

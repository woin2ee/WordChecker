import Foundation

extension UserSettingsViewController {
   
    /// 화면에 섹션들이 실제 표시되는 순서대로 cases 가 선언되어 있습니다.
    enum SectionID: Int, Hashable, Sendable {
        case changeLanguage = 0
        case notifications
        case googleDriveSync
        case signOut
    }
}

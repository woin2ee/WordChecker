extension UserSettingsViewController {
    
    /// 화면에 아이템들이 실제 표시되는 순서대로 cases 가 선언되어 있습니다.
    enum ItemID {

        case changeSourceLanguage
        case changeTargetLanguage

        case notifications
        case general

        case googleDriveUpload
        case googleDriveDownload

        case googleDriveSignOut
    }
}

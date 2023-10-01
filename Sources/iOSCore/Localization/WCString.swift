//
//  WCString.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Foundation

struct WCString {

    private init() {}

    static let ok = NSLocalizedString("ok", bundle: Bundle.module, comment: "")
    static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    static let notice = NSLocalizedString("notice", bundle: Bundle.module, comment: "")

    static let translation_site_alert_message = NSLocalizedString("translation_site_alert_message", bundle: Bundle.module, comment: "")

    static let add = NSLocalizedString("add", bundle: Bundle.module, comment: "")
    static let addWord = NSLocalizedString("addWord", bundle: Bundle.module, comment: "")
    static let quick_add_word = NSLocalizedString("quick_add_word", bundle: Bundle.module, comment: "")
    static let next = NSLocalizedString("next", bundle: Bundle.module, comment: "")
    static let previous = NSLocalizedString("previous", bundle: Bundle.module, comment: "")
    static let noWords = NSLocalizedString("noWords", bundle: Bundle.module, comment: "")
    static let list = NSLocalizedString("list", bundle: Bundle.module, comment: "")
    static let wordList = NSLocalizedString("wordList", bundle: Bundle.module, comment: "")
    static let delete = NSLocalizedString("delete", bundle: Bundle.module, comment: "")
    static let deleteWord = NSLocalizedString("deleteWord", bundle: Bundle.module, comment: "")
    static let edit = NSLocalizedString("edit", bundle: Bundle.module, comment: "")
    static let editWord = NSLocalizedString("editWord", bundle: Bundle.module, comment: "")
    static let shuffleOrder = NSLocalizedString("shuffleOrder", bundle: Bundle.module, comment: "")

    static let translate = NSLocalizedString("translate", bundle: Bundle.module, comment: "")
    static let source_language = NSLocalizedString("source_language", bundle: Bundle.module, comment: "")
    static let translation_language = NSLocalizedString("translation_language", bundle: Bundle.module, comment: "")
    static let sync_google_drive = NSLocalizedString("sync_google_drive", bundle: Bundle.module, comment: "")
    static let google_drive_upload = NSLocalizedString("google_drive_upload", bundle: Bundle.module, comment: "")
    static let google_drive_upload_successfully = NSLocalizedString("google_drive_upload_successfully", bundle: Bundle.module, comment: "")

    static let google_drive_download = NSLocalizedString("google_drive_download", bundle: Bundle.module, comment: "")
    static let google_drive_download_successfully = NSLocalizedString("google_drive_download_successfully", bundle: Bundle.module, comment: "")
    static let google_drive_logout = NSLocalizedString("google_drive_logout", bundle: Bundle.module, comment: "")
    static let signed_out_of_google_drive = NSLocalizedString("signed_out_of_google_drive", bundle: Bundle.module, comment: "")

    static let synchronize_to_google_drive = NSLocalizedString("synchronize_to_google_drive", bundle: Bundle.module, comment: "")

    static let languages = NSLocalizedString("languages", bundle: Bundle.module, comment: "")

    static let word = NSLocalizedString("word", bundle: Bundle.module, comment: "")
    static let done = NSLocalizedString("done", bundle: Bundle.module, comment: "")
    static let details = NSLocalizedString("details", bundle: Bundle.module, comment: "")
    static let memorizing = NSLocalizedString("memorizing", bundle: Bundle.module, comment: "")
    static let memorized = NSLocalizedString("memorized", bundle: Bundle.module, comment: "")
    static let memorization = NSLocalizedString("memorization", bundle: Bundle.module, comment: "")
    static let check = NSLocalizedString("check", bundle: Bundle.module, comment: "")
    static let newWord = NSLocalizedString("newWord", bundle: Bundle.module, comment: "")
    static let discardChanges = NSLocalizedString("discardChanges", bundle: Bundle.module, comment: "")
    static let all = NSLocalizedString("all", bundle: Bundle.module, comment: "")
    static let settings = NSLocalizedString("settings", bundle: Bundle.module, comment: "")
    static let there_are_no_words = NSLocalizedString("there_are_no_words", bundle: Bundle.module, comment: "")
    static func word_added_successfully(word: String) -> String {
        let localizedString = NSLocalizedString("%@_added_successfully", bundle: Bundle.module, comment: "단어 추가 완료 후 표시되는 메세지")
        return .init(format: localizedString, arguments: [word])
    }

}

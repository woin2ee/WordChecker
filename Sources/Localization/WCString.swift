//
//  WCString.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Foundation

public struct WCString {

    private init() {}

    public static let ok = NSLocalizedString("ok", bundle: Bundle.module, comment: "")
    public static let cancel = NSLocalizedString("cancel", bundle: Bundle.module, comment: "")
    public static let notice = NSLocalizedString("notice", bundle: Bundle.module, comment: "")

    public static let translation_site_alert_message = NSLocalizedString("translation_site_alert_message", bundle: Bundle.module, comment: "")

    public static let add = NSLocalizedString("add", bundle: Bundle.module, comment: "")
    public static let addWord = NSLocalizedString("addWord", bundle: Bundle.module, comment: "")
    public static let quick_add_word = NSLocalizedString("quick_add_word", bundle: Bundle.module, comment: "")
    public static let next = NSLocalizedString("next", bundle: Bundle.module, comment: "")
    public static let previous = NSLocalizedString("previous", bundle: Bundle.module, comment: "")
    public static let noWords = NSLocalizedString("noWords", bundle: Bundle.module, comment: "")
    public static let list = NSLocalizedString("list", bundle: Bundle.module, comment: "")
    public static let wordList = NSLocalizedString("wordList", bundle: Bundle.module, comment: "")
    public static let delete = NSLocalizedString("delete", bundle: Bundle.module, comment: "")
    public static let deleteWord = NSLocalizedString("deleteWord", bundle: Bundle.module, comment: "")
    public static let edit = NSLocalizedString("edit", bundle: Bundle.module, comment: "")
    public static let editWord = NSLocalizedString("editWord", bundle: Bundle.module, comment: "")
    public static let shuffleOrder = NSLocalizedString("shuffleOrder", bundle: Bundle.module, comment: "")

    public static let translate = NSLocalizedString("translate", bundle: Bundle.module, comment: "")
    public static let source_language = NSLocalizedString("source_language", bundle: Bundle.module, comment: "")
    public static let translation_language = NSLocalizedString("translation_language", bundle: Bundle.module, comment: "")
    public static let sync_google_drive = NSLocalizedString("sync_google_drive", bundle: Bundle.module, comment: "")
    public static let google_drive_upload = NSLocalizedString("google_drive_upload", bundle: Bundle.module, comment: "")
    public static let upload_successful = NSLocalizedString("upload_successful", bundle: Bundle.module, comment: "")

    public static let google_drive_download = NSLocalizedString("google_drive_download", bundle: Bundle.module, comment: "")
    public static let download_successful = NSLocalizedString("download_successful", bundle: Bundle.module, comment: "")

    public static let synchronize_to_google_drive = NSLocalizedString("synchronize_to_google_drive", bundle: Bundle.module, comment: "")

    public static let languages = NSLocalizedString("languages", bundle: Bundle.module, comment: "")
    public static let korean = NSLocalizedString("korean", bundle: Bundle.module, comment: "")
    public static let english = NSLocalizedString("english", bundle: Bundle.module, comment: "")
    public static let japanese = NSLocalizedString("japanese", bundle: Bundle.module, comment: "")
    public static let chinese = NSLocalizedString("chinese", bundle: Bundle.module, comment: "")
    public static let french = NSLocalizedString("french", bundle: Bundle.module, comment: "")
    public static let spanish = NSLocalizedString("spanish", bundle: Bundle.module, comment: "")
    public static let italian = NSLocalizedString("italian", bundle: Bundle.module, comment: "")
    public static let german = NSLocalizedString("german", bundle: Bundle.module, comment: "")
    public static let russian = NSLocalizedString("russian", bundle: Bundle.module, comment: "")

    public static let word = NSLocalizedString("word", bundle: Bundle.module, comment: "")
    public static let done = NSLocalizedString("done", bundle: Bundle.module, comment: "")
    public static let details = NSLocalizedString("details", bundle: Bundle.module, comment: "")
    public static let memorizing = NSLocalizedString("memorizing", bundle: Bundle.module, comment: "")
    public static let memorized = NSLocalizedString("memorized", bundle: Bundle.module, comment: "")
    public static let memorization = NSLocalizedString("memorization", bundle: Bundle.module, comment: "")
    public static let check = NSLocalizedString("check", bundle: Bundle.module, comment: "")
    public static let newWord = NSLocalizedString("newWord", bundle: Bundle.module, comment: "")
    public static let discardChanges = NSLocalizedString("discardChanges", bundle: Bundle.module, comment: "")
    public static let all = NSLocalizedString("all", bundle: Bundle.module, comment: "")
    public static let settings = NSLocalizedString("settings", bundle: Bundle.module, comment: "")
    public static let there_are_no_words = NSLocalizedString("there_are_no_words", bundle: Bundle.module, comment: "")
    public static func word_added_successfully(word: String) -> String {
        let localizedString = NSLocalizedString("%@_added_successfully", bundle: Bundle.module, comment: "단어 추가 완료 후 표시되는 메세지")
        return .init(format: localizedString, arguments: [word])
    }

}

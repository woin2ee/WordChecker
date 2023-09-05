//
//  WCString.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Foundation

private final class BundleFinder {}

struct WCString {

    private init() {}

    private static let bundle: Bundle = .init(for: BundleFinder.self)

    static let cancel = NSLocalizedString("cancel", bundle: bundle, comment: "")
    static let add = NSLocalizedString("add", bundle: bundle, comment: "")
    static let addWord = NSLocalizedString("addWord", bundle: bundle, comment: "")
    static let next = NSLocalizedString("next", bundle: bundle, comment: "")
    static let previous = NSLocalizedString("previous", bundle: bundle, comment: "")
    static let noWords = NSLocalizedString("noWords", bundle: bundle, comment: "")
    static let list = NSLocalizedString("list", bundle: bundle, comment: "")
    static let wordList = NSLocalizedString("wordList", bundle: bundle, comment: "")
    static let delete = NSLocalizedString("delete", bundle: bundle, comment: "")
    static let deleteWord = NSLocalizedString("deleteWord", bundle: bundle, comment: "")
    static let edit = NSLocalizedString("edit", bundle: bundle, comment: "")
    static let editWord = NSLocalizedString("editWord", bundle: bundle, comment: "")
    static let shuffleOrder = NSLocalizedString("shuffleOrder", bundle: bundle, comment: "")
    static let translate = NSLocalizedString("translate", bundle: bundle, comment: "")
    static let word = NSLocalizedString("word", bundle: bundle, comment: "")
    static let done = NSLocalizedString("done", bundle: bundle, comment: "")
    static let details = NSLocalizedString("details", bundle: bundle, comment: "")

}

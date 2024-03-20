//
//  Word.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation
import Realm
import RealmSwift

internal final class WordObject: Object {

//    @Persisted(primaryKey: true) var objectID: ObjectId = .generate()
    @Persisted(primaryKey: true) var uuid: UUID = .init()

    @Persisted var word: String

    @Persisted var isMemorized: Bool = false

    convenience init(word: String) {
        self.init()
        self.word = word
    }

    convenience init(uuid: UUID, word: String, isMemorized: Bool) {
        self.init()
        self.uuid = uuid
        self.word = word
        self.isMemorized = isMemorized
    }

}

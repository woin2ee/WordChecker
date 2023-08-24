//
//  Word.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation
import RealmSwift

final class Word: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var word: String
    
    convenience init(word: String) {
        self.init()
        self.word = word
    }
    
}

//
//  WCRepository.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/24.
//

import Foundation
import RealmSwift

final class WCRepository {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func saveWord(_ word: Word) throws {
        try realm.write {
            realm.add(word)
        }
    }
    
    func getAllWords() -> [Word] {
        let words = realm.objects(Word.self)
        return Array(words)
    }
    
}

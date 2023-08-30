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

    func getWord(by objectID: ObjectId) throws -> Word {
        guard let object = realm.object(ofType: Word.self, forPrimaryKey: objectID) else {
            throw RealmError.notMatchedObjectID(type: Word.self, objectID: objectID)
        }
        return object
    }

    func getAllWords() -> [Word] {
        let words = realm.objects(Word.self)
        return Array(words)
    }

    func deleteWord(by objectID: ObjectId) throws {
        let object = try getWord(by: objectID)
        try realm.write {
            self.realm.delete(object)
        }
    }

    func updateWord(for objectID: ObjectId, withNewWord newWord: String) throws {
        let updateTarget = try getWord(by: objectID)
        try realm.write {
            updateTarget.word = newWord
        }
    }

}

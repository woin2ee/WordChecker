//
//  WordRepository.swift
//  RealmPlatform
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Foundation
import Realm
import RealmSwift

internal final class WordRepository: WordRepositoryProtocol {

    let realm: Realm
    let realmConfinedQueue: DispatchQueue

    init(realm: Realm, realmConfinedQueue: DispatchQueue) {
        self.realm = realm
        self.realmConfinedQueue = realmConfinedQueue
    }

    func save(_ word: Word) throws {
        try realmConfinedQueue.sync {
            try realm.write {
                realm.add(word.toObjectModel(), update: .modified)
            }
        }
    }

    func getAllWords() -> [Word] {
        return realmConfinedQueue.sync {
            return findAll()
                .compactMap { try? $0.toDomain() }
        }
    }

    func getWord(by uuid: UUID) -> Word? {
        return realmConfinedQueue.sync {
            return try? find(by: uuid)?.toDomain()
        }
    }

    func getWords(by word: String) -> [Word] {
        return realmConfinedQueue.sync {
            let results = realm.objects(WordObject.self)
                .where { $0.word.equals(word, options: .caseInsensitive) }
                .compactMap { try? $0.toDomain() }
            return Array(results)
        }
    }

    func deleteWord(by uuid: UUID) throws {
        try realmConfinedQueue.sync {
            guard let object = find(by: uuid) else {
                return
            }
            
            try realm.write {
                self.realm.delete(object)
            }
        }
    }

    func getUnmemorizedList() -> [Word] {
        return realmConfinedQueue.sync {
            return findAll()
                .filter { $0.isMemorized == false }
                .compactMap { try? $0.toDomain() }
        }
    }

    func getMemorizedList() -> [Word] {
        return realmConfinedQueue.sync {
            return findAll()
                .filter { $0.isMemorized == true }
                .compactMap { try? $0.toDomain() }
        }
    }

    func reset(to wordList: [Word]) throws {
        try realmConfinedQueue.sync {
            try realm.write {
                self.realm.deleteAll()
                
                let newList = wordList.map { $0.toObjectModel() }
                self.realm.add(newList)
            }
        }
    }
}

// MARK: Helpers

extension WordRepository {

    private func find(by uuid: UUID) -> WordObject? {
        // Because it is a helper method, it is called from a confined queue.
        guard let object = realm.object(ofType: WordObject.self, forPrimaryKey: uuid) else {
            return nil
        }
        return object
    }

    private func findAll() -> [WordObject] {
        // Because it is a helper method, it is called from a confined queue.
        let words = realm.objects(WordObject.self)
        return Array(words)
    }
}

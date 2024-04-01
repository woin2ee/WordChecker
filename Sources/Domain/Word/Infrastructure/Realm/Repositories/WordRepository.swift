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
    let realmConfinedQueue: DispatchQueue?

    init(realm: Realm, realmConfinedQueue: DispatchQueue? = nil) {
        self.realm = realm
        self.realmConfinedQueue = realmConfinedQueue
    }

    func save(_ word: Word) throws {
        if let realmConfinedQueue = realmConfinedQueue {
            try realmConfinedQueue.sync {
                try _save(word)
            }
        } else {
            try _save(word)
        }
    }

    private func _save(_ word: Word) throws {
        try realm.write {
            realm.add(word.toObjectModel(), update: .modified)
        }
    }

    func getAllWords() -> [Word] {
        if let realmConfinedQueue = realmConfinedQueue {
            return realmConfinedQueue.sync {
                return _getAllWords()
            }
        } else {
            return _getAllWords()
        }
    }

    private func _getAllWords() -> [Word] {
        return findAll()
            .compactMap { try? $0.toDomain() }
    }

    func getWord(by uuid: UUID) -> Word? {
        if let realmConfinedQueue = realmConfinedQueue {
            return realmConfinedQueue.sync {
                return _getWord(by: uuid)
            }
        } else {
            return _getWord(by: uuid)
        }
    }

    private func _getWord(by uuid: UUID) -> Word? {
        return try? find(by: uuid)?.toDomain()
    }

    func getWords(by word: String) -> [Word] {
        if let realmConfinedQueue = realmConfinedQueue {
            return realmConfinedQueue.sync {
                return _getWords(by: word)
            }
        } else {
            return _getWords(by: word)
        }
    }

    private func _getWords(by word: String) -> [Word] {
        let results = realm.objects(WordObject.self)
            .where { $0.word.equals(word, options: .caseInsensitive) }
            .compactMap { try? $0.toDomain() }
        return Array(results)
    }

    func deleteWord(by uuid: UUID) throws {
        if let realmConfinedQueue = realmConfinedQueue {
            try realmConfinedQueue.sync {
                try _deleteWord(by: uuid)
            }
        } else {
            try _deleteWord(by: uuid)
        }
    }

    private func _deleteWord(by uuid: UUID) throws {
        guard let object = find(by: uuid) else {
            return
        }

        try realm.write {
            self.realm.delete(object)
        }
    }

    func getUnmemorizedList() -> [Word] {
        if let realmConfinedQueue = realmConfinedQueue {
            return realmConfinedQueue.sync {
                return _getUnmemorizedList()
            }
        } else {
            return _getUnmemorizedList()
        }
    }

    private func _getUnmemorizedList() -> [Word] {
        return findAll()
            .filter { $0.isMemorized == false }
            .compactMap { try? $0.toDomain() }
    }

    func getMemorizedList() -> [Word] {
        if let realmConfinedQueue = realmConfinedQueue {
            return realmConfinedQueue.sync {
                return _getMemorizedList()
            }
        } else {
            return _getMemorizedList()
        }
    }

    private func _getMemorizedList() -> [Word] {
        return findAll()
            .filter { $0.isMemorized == true }
            .compactMap { try? $0.toDomain() }
    }

    func reset(to wordList: [Word]) throws {
        if let realmConfinedQueue = realmConfinedQueue {
            try realmConfinedQueue.sync {
                try _reset(to: wordList)
            }
        } else {
            try _reset(to: wordList)
        }
    }

    private func _reset(to wordList: [Word]) throws {
        try realm.write {
            self.realm.deleteAll()

            let newList = wordList.map { $0.toObjectModel() }
            self.realm.add(newList)
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

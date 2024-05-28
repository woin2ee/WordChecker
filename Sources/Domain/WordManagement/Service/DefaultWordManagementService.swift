import Foundation

internal final class DefaultWordManagementService: WordManagementService {

    private let wordRepository: WordRepository
    private let wordDuplicateSpecification: WordDuplicateSpecification

    init(wordRepository: WordRepository, wordDuplicateSpecification: WordDuplicateSpecification) {
        self.wordRepository = wordRepository
        self.wordDuplicateSpecification = wordDuplicateSpecification
    }

    func addNewWord(_ word: String, with id: UUID) throws {
        let newWordEntity = try Word(uuid: id, word: word)

        guard wordDuplicateSpecification.isSatisfied(for: newWordEntity) else {
            throw WordServiceError.saveFailed(reason: .duplicatedWord(word: word))
        }

        try wordRepository.save(newWordEntity)
    }

    func deleteWord(by uuid: UUID) throws {
        try wordRepository.deleteWord(by: uuid)
    }

    func fetchWordList() -> [Word] {
        return wordRepository.getAllWords()
    }

    func fetchUnmemorizedWordList() -> [Word] {
        return wordRepository.getUnmemorizedList()
    }

    func fetchMemorizedWordList() -> [Word] {
        return wordRepository.getMemorizedList()
    }

    func fetchWord(by uuid: UUID) -> Word? {
        return wordRepository.getWord(by: uuid)
    }

    func updateWord(with newAttribute: WordAttribute, id: UUID) throws {
        if newAttribute.word == nil, newAttribute.memorizationState == nil {
            return
        }

        guard var wordEntity = wordRepository.getWord(by: id) else {
            throw WordServiceError.retrieveFailed(reason: .uuidInvalid(uuid: id))
        }

        if let newWord = newAttribute.word {
            try wordEntity.setWord(newWord)
            guard wordDuplicateSpecification.isSatisfied(for: wordEntity) else {
                throw WordServiceError.saveFailed(reason: .duplicatedWord(word: newWord))
            }
        }

        if let newState = newAttribute.memorizationState {
            wordEntity.memorizationState = newState
        }

        try wordRepository.save(wordEntity)
    }

    func markWordsAsMemorized(by uuids: [UUID]) throws {
        try uuids.compactMap { wordRepository.getWord(by: $0) }
            .forEach { word in
                var word = word
                word.memorizationState = .memorized
                try wordRepository.save(word)
            }
    }

    func isWordDuplicated(_ word: String) throws -> Bool {
        let tempEntity = try Word(word: word)
        return wordDuplicateSpecification.isSatisfied(for: tempEntity) ? false : true
    }

    func reset(to newWordList: [Word]) throws {
        try wordRepository.reset(to: newWordList)
    }
}

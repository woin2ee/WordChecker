import Foundation

public protocol WordManagementService {
    func addNewWord(_ word: String, with id: UUID) throws
    func deleteWord(by uuid: UUID) throws
    func fetchWordList() -> [Word]
    func fetchUnmemorizedWordList() -> [Word]
    func fetchMemorizedWordList() -> [Word]
    func fetchWord(by uuid: UUID) -> Word?
    func updateWord(with newAttribute: WordAttribute, id: UUID) throws
    func markWordsAsMemorized(by uuids: [UUID]) throws
    func isWordDuplicated(_ word: String) throws -> Bool
    func reset(to newWordList: [Word]) throws
}

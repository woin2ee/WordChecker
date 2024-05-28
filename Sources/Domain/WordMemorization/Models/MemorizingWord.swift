import Domain_Core
import Foundation
import FoundationPlus

public struct MemorizingWord: Entity, Equatable, Hashable {
    
    public let id: UUID
    public var word: String
    var isChecked: Bool

    public init(id: UUID, word: String, isChecked: Bool) throws {
        guard word.hasElements else { throw EntityError.createFailed(reason: .containsInvalidValue) }
        
        self.id = id
        self.word = word
        self.isChecked = isChecked
    }
}

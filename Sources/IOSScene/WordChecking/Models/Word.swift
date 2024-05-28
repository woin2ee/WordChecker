import Domain_WordManagement
import Domain_WordMemorization
import Foundation

struct Word {
    let id: UUID
    let word: String
}

extension Domain_WordMemorization.MemorizingWord {
    func toDTO() -> Word {
        Word(id: self.id, word: self.word)
    }
}

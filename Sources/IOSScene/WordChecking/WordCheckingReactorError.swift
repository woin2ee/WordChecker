import Foundation

enum WordCheckingReactorError: Error {

    enum AddWordFailureReason {
        case duplicatedWord
        case unknown
    }

    case addWordFailed(reason: AddWordFailureReason?, word: String)
}

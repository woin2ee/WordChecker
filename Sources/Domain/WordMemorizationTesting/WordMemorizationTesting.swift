@testable import Domain_WordMemorization

public typealias FakeWordMemorizationService = DefaultWordMemorizationService

extension FakeWordMemorizationService {
    public static func fake() -> WordMemorizationService {
        return DefaultWordMemorizationService()
    }
}

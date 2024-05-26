import Swinject

public final class DomainWordMemorizationAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(WordMemorizationService.self) { _ in
            return DefaultWordMemorizationService()
        }
    }
}

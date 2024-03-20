import Swinject

public final class DomainGoogleDriveAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(GoogleDriveServiceProtocol.self) { _ in
            return GoogleDriveService.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }
}

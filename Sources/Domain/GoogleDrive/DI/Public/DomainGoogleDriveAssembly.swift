import Swinject

public final class DomainGoogleDriveAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(GoogleDriveService.self) { _ in
            return DefaultGoogleDriveService.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }
}

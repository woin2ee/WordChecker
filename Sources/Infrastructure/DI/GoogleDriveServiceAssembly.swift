import Domain
import Swinject

final class GoogleDriveServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Domain.GoogleDriveService.self) { _ in
            return GoogleDriveService.init(gidSignIn: .sharedInstance)
        }
        .inObjectScope(.container)
    }

}

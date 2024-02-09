import Swinject

public final class InfrastructureAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GoogleDriveServiceAssembly(),
            UserSettingsRepositoryAssembly(),
            WordRepositoryAssembly(),
            UnmemorizedWordListRepositoryAssembly(),
            LocalNotificationServiceAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

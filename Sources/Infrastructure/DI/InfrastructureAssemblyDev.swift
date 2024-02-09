import Swinject

public final class InfrastructureAssemblyDev: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            GoogleDriveServiceAssembly(),
            UserSettingsRepositoryAssemblyDev(),
            WordRepositoryAssemblyDev(),
            UnmemorizedWordListRepositoryAssembly(),
            LocalNotificationServiceAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

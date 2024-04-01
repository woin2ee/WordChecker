import Foundation
import Swinject
import SwinjectExtension

public struct DomainWordAssemblyDev: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let subAssemblies: [Assembly] = [
            WordRepositoryAssemblyDev(),
            UnmemorizedWordListRepositoryAssembly(),
            WordDuplicateSpecificationAssembly(),
            WordServiceAssembly(),
        ]
        subAssemblies.forEach { subAssembly in
            subAssembly.assemble(container: container)
        }
    }
}

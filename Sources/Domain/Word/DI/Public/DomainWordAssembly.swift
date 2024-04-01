import Foundation
import Swinject
import SwinjectExtension

public struct DomainWordAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let subAssemblies: [Assembly] = [
            WordRepositoryAssembly(),
            UnmemorizedWordListRepositoryAssembly(),
            WordDuplicateSpecificationAssembly(),
            WordServiceAssembly(),
        ]
        subAssemblies.forEach { subAssembly in
            subAssembly.assemble(container: container)
        }
    }
}

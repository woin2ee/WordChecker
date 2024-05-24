import Swinject

public let container = AppContainer()

public struct AppContainer {
    
    private let assembler = Assembler()
    
    /// Retrieves the instance with the specified service type.
    ///
    /// If not found service, occur fatalError.
    ///
    /// - Parameter serviceType: The service type to resolve.
    /// - Returns: The resolved service type instance.
    public func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let resolved = assembler.resolver.resolve(serviceType) else {
            resolveOrFatalError(Service.self)
        }
        return resolved
    }
    
    public func resolve<Service, Arg1>(_ serviceType: Service.Type = Service.self, argument: Arg1) -> Service {
        guard let resolved = assembler.resolver.resolve(serviceType, argument: argument) else {
            resolveOrFatalError(Service.self)
        }
        return resolved
    }
    
    public func apply(assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
}

func resolveOrFatalError<Service>(_ serviceType: Service.Type, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Failed to resolve for '\(serviceType.self)' type.", file: file, line: line)
}

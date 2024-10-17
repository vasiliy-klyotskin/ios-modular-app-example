//
//  Container.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/19/24.
//

public final class Container: Resolver {
    private var instances: [String: Any] = [:]
    
    public init() {}
    
    public func resolve<T>(_ type: T.Type, for key: String? = nil) -> T {
        if let instance = instances[key ?? String(describing: type)] as? T {
            return instance
        } else {
            fatalError("Please, register \(String(describing: type))")
        }
    }

    public func register<T>(_ type: T.Type, _ instance: T, for key: String? = nil) -> Container {
        instances[key ?? String(describing: type)] = instance
        return self
    }
}

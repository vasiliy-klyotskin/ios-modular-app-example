//
//  Resolver.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/18/24.
//

import Foundation

public protocol Resolver {
    func resolve<T>(_ type: T.Type, for key: String?) -> T
}

extension Resolver {
    public func get<T>(_ type: T.Type, for key: String? = nil) -> T {
        resolve(type, for: key)
    }
}

extension Resolver {
    public var defaultUIScheduler: AnySchedulerOf<DispatchQueue> {
        self.get(AnySchedulerOf<DispatchQueue>.self)
    }
}

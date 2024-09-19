//
//  Resolver.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/18/24.
//

import Foundation

protocol Resolver {
    func resolve<T>(_ type: T.Type, for key: String?) -> T
}

extension Resolver {
    func get<T>(_ type: T.Type, for key: String? = nil) -> T {
        resolve(type, for: key)
    }
}

extension Resolver {
    var remoteClient: RemoteClient { self.get(RemoteClient.self) }
    var uiScheduler: AnySchedulerOf<DispatchQueue> { self.get(AnySchedulerOf<DispatchQueue>.self) }
    var appToast: ToastViewModel { self.get(ToastViewModel.self) }
}

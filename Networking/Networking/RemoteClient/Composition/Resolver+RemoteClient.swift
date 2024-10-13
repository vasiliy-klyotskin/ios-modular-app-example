//
//  RemoteClient+Resolver.swift
//  Networking
//
//  Created by Василий Клецкин on 10/9/24.
//

import CompositionSupport

extension Resolver {
    public var defaultRemoteClient: RemoteClient {
        self.get(RemoteClient.self)
    }
}

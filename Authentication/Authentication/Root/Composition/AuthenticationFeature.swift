//
//  Authentication+Feature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Foundation
import CompositionSupport

public typealias AuthenticationFeature = AuthenticationFlow

public struct AuthenticationEvents {
    let onSuccess: (AuthenticationTokens) -> Void
    
    public init(onSuccess: @escaping (AuthenticationTokens) -> Void) {
        self.onSuccess = onSuccess
    }
}

public struct AuthenticationEnvironment {
    let keychain: KeychainStorage
    private let resolver: Resolver

    public static func from(resolver: Resolver) -> AuthenticationEnvironment {
        .init(
            keychain: resolver.get(KeychainStorage.self),
            resolver: resolver
        )
    }
    
    func login() -> LoginEnvironment { .from(resolver: resolver) }
    func oAuth() -> OAuthEnvironment { .from(resolver: resolver) }
    func register() -> RegisterEnvironment { .from(resolver: resolver) }
    func enterCode() -> EnterCodeEnvironment { .from(resolver: resolver) }
}

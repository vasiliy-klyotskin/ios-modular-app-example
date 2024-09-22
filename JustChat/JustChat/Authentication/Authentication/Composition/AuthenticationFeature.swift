//
//  Authentication+Feature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Foundation

typealias AuthenticationFeature = AuthenticationFlow

struct AuthenticationEvents {
    let onSuccess: (AuthenticationTokens) -> Void
}

struct AuthenticationEnvironment {
    let keychain: KeychainStorage
    private let resolver: Resolver

    static func from(resolver: Resolver) -> AuthenticationEnvironment {
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

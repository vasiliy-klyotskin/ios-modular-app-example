//
//  AuthTokensService.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

final class AuthTokensService {
    static var accessTokenId: String { "ACCESS_TOKEN_KEY" }
    static var refreshTokenId: String { "REFRESH_TOKEN_KEY" }
    
    let keychain: KeychainStorage
    
    init(keychain: KeychainStorage) {
        self.keychain = keychain
    }

    func save(tokens: AuthenticationTokens) {
        keychain.delete(for: Self.accessTokenId)
        keychain.delete(for: Self.refreshTokenId)
        keychain.save(for: Self.accessTokenId, value: tokens.accessToken)
        keychain.save(for: Self.refreshTokenId, value: tokens.refreshToken)
    }
}

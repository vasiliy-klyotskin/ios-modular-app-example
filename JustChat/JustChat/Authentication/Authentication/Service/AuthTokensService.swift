//
//  AuthTokensService.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

final class AuthTokensService {
    let keychain: KeychainStorage
    
    init(keychain: KeychainStorage) {
        self.keychain = keychain
    }
    
    static var accessTokenId: String { "ACCESS_TOKEN_KEY" }
    static var refreshTokenId: String { "REFRESH_TOKEN_KEY" }
    
    func save(accessToken: String, refreshToken: String) {
        keychain.delete(for: Self.accessTokenId)
        keychain.delete(for: Self.refreshTokenId)
        keychain.save(for: Self.accessTokenId, value: accessToken)
        keychain.save(for: Self.refreshTokenId, value: refreshToken)
    }
}

extension AuthTokensService {
    func save(_ model: EnterCodeSubmitModel) {
        save(accessToken: model.accessToken, refreshToken: model.refreshToken)
    }
    
    func save(_ model: OAuthModel) {
        save(accessToken: model.accessToken, refreshToken: model.refreshToken)
    }
}

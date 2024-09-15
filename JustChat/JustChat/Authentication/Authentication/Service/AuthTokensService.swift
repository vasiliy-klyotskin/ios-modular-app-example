//
//  AuthTokensService.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

final class AuthTokensService {
    let storage: KeychainStorage
    
    init(storage: KeychainStorage) {
        self.storage = storage
    }
    
    static var accessTokenId: String { "ACCESS_TOKEN_KEY" }
    static var refreshTokenId: String { "REFRESH_TOKEN_KEY" }
    
    func save(accessToken: String, refreshToken: String) {
        storage.delete(for: Self.accessTokenId)
        storage.delete(for: Self.refreshTokenId)
        storage.save(for: Self.accessTokenId, value: accessToken)
        storage.save(for: Self.refreshTokenId, value: refreshToken)
    }
}

extension AuthTokensService {
    func save(_ model: EnterCodeSubmitModel) {
        save(accessToken: model.accessToken, refreshToken: model.refreshToken)
    }
}

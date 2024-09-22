//
//  AuthenticationSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation
@testable import JustChat

final class AuthenticationSpy {
    let keychain = KeychainStorage(service: "any")
    let remote = RemoteSpy()
    let timer = TimerSpy()
    let uiScheduler = DispatchQueue.test
    let oAuth = AuthSessionSpy()
    
    var successMessages: [AuthenticationTokens] = []
    
    func processSuccess(model: AuthenticationTokens) {
        successMessages.append(model)
    }
    
    func finishRemoteWithError(index: Int) {
        remote.finishWithError(index: index)
        uiScheduler.advance()
    }
    
    func finishRemoteWith(response: RemoteResponse, index: Int) {
        remote.finishWith(response: response, index: index)
        uiScheduler.advance()
    }
    
    var storedAccessToken: String? {
        keychain.read(for: AuthTokensService.accessTokenId)
    }
    
    var storedRefreshToken: String? {
        keychain.read(for: AuthTokensService.refreshTokenId)
    }
    
    func clearPersistedValues() {
        keychain.flush()
    }
}

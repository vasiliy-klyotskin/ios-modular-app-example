//
//  AuthenticationSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation
@testable import JustChat

final class AuthenticationSpy {
    let storage = KeychainStorage(service: "any")
    let remote = RemoteSpy()
    let timer = TimerSpy()
    let scheduler = DispatchQueue.test
    
    var successMessages = 0
    
    func processSuccess() {
        successMessages += 1
    }
    
    func finishRemoteWithError(index: Int) {
        remote.finishWithError(index: index)
        scheduler.advance()
    }
    
    func finishRemoteWith(response: RemoteResponse, index: Int) {
        remote.finishWith(response: response, index: index)
        scheduler.advance()
    }
    
    var storedAccessToken: String? {
        storage.read(for: AuthTokensService.accessTokenId)
    }
    
    var storedRefreshToken: String? {
        storage.read(for: AuthTokensService.refreshTokenId)
    }
    
    func clearPersistedValues() {
        storage.flush()
    }
}

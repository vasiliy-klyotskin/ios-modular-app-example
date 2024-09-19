//
//  OAuthSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

import Foundation
import Combine
@testable import JustChat

final class OAuthSpy {
    var isLoadingIndicatorVisible = false
    var generalError: String? = nil
    
    let remote = RemoteSpy()
    let uiScheduler = DispatchQueue.test
    let session = AuthSessionSpy()
    
    var successes: [OAuthModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: OAuthTests.Sut) {
        sut.toast.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.$isLoadingIndicatorVisible.bind(\.isLoadingIndicatorVisible, to: self, storeIn: &cancellables)
    }
    
    func keepSuccess(model: OAuthModel) {
        successes.append(model)
    }
    
    func finishRemoteWithError(index: Int) {
        remote.finishWithError(index: index)
        uiScheduler.advance()
    }
    
    func finishRemoteWith(response: RemoteResponse, index: Int) {
        remote.finishWith(response: response, index: index)
        uiScheduler.advance()
    }
}

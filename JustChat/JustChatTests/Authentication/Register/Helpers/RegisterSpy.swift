//
//  RegisterFeatureSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
import Combine
@testable import JustChat

final class RegisterFeatureSpy {
    var isLoadingIndicatorDisplayed: Bool { submitButtonConfig.isLoadingIndicatorShown }
    var isContentDisabled = false
    var emailError: String?
    var usernameError: String?
    var generalError: String?
    var successes = [RegisterModel]()
    var loginCalls = 0
    
    let remote = RemoteSpy()
    let uiScheduler = DispatchQueue.test
    
    private var cancellables = Set<AnyCancellable>()
    private var submitButtonConfig: ButtonConfig = .standard(title: "")
    
    func startSpying(sut: RegisterTests.Sut) {
        sut.$isContentDisabled.bind(\.isContentDisabled, to: self, storeIn: &cancellables)
        sut.$submitButtonConfig.bind(\.submitButtonConfig, to: self, storeIn: &cancellables)
        sut.toast.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.username.$error.bind(\.usernameError, to: self, storeIn: &cancellables)
        sut.email.$error.bind(\.emailError, to: self, storeIn: &cancellables)
    }
    
    func finishRemoteWithError(index: Int) {
        remote.finishWithError(index: index)
        uiScheduler.advance()
    }
    
    func finishRemoteWith(response: RemoteResponse, index: Int) {
        remote.finishWith(response: response, index: index)
        uiScheduler.advance()
    }
    
    func keepRegisterModel(_ model: RegisterModel) {
        successes.append(model)
    }
    
    func incrementLoginCalls() {
        loginCalls += 1
    }
}

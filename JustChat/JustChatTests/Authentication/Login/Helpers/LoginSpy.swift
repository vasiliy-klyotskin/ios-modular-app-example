//
//  LoginSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Foundation
import Combine
@testable import JustChat

final class LoginFeatureSpy {
    var isLoadingIndicatorDisplayed: Bool { submitButtonConfig.isLoadingIndicatorShown }
    var isContentDisabled = false
    var loginError: String?
    var generalError: String?
    
    var successes = [LoginModel]()
    var regiterCalls = 0
    var googleAuthCalls = 0
    
    let remote = RemoteSpy()
    
    private var cancellables = Set<AnyCancellable>()
    private var submitButtonConfig: ButtonConfig = .standard(title: "")
    
    func startSpying(sut: LoginTests.Sut) {
        sut.$isContentDisabled.bind(\.isContentDisabled, to: self, storeIn: &cancellables)
        sut.$submitButtonConfig.bind(\.submitButtonConfig, to: self, storeIn: &cancellables)
        sut.toast.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.input.$error.bind(\.loginError, to: self, storeIn: &cancellables)
    }
    
    func keepLoginModel(_ model: LoginModel) {
        successes.append(model)
    }
    
    func incrementRegister() {
        regiterCalls += 1
    }
    
    func incrementGoogleAuth() {
        googleAuthCalls += 1
    }
}

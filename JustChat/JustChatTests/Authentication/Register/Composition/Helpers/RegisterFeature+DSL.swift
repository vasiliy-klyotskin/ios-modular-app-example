//
//  RegisterFeature+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

@testable import JustChat

extension RegisterFeatureTests.Sut {
    func initiateRegistration() {
        registerVm.submit()
    }
    
    func changeEmailInput(_ value: String) {
        emailInputVm.input = value
    }
    
    func changeUsernameInput(_ value: String) {
        usernameInputVm.input = value
    }
    
    func simulateLoginTap() {
        registerVm.loginTapped()
    }
}

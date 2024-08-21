//
//  RegisterFeature+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

@testable import JustChat

extension RegisterFeatureTests.Sut {
    func initiateRegistration() {
        self.registerVm.submit()
    }
    
    func changeEmailInput(_ value: String) {
        self.emailInputVm.input = value
    }
    
    func changeUsernameInput(_ value: String) {
        self.usernameInputVm.input = value
    }
}

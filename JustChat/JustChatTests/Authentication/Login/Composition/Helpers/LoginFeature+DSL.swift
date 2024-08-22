//
//  Login+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

@testable import JustChat

extension LoginFeatureTests.Sut {
    func initiateLoginSubmit() {
        submitVm.submit()
    }
    
    func changeLoginInput(_ value: String) {
        inputVm.input = value
    }
    
    func simulateGoogleAuthTap() {
        submitVm.googleAuthTapped()
    }
    
    func simulateRegisterTap() {
        submitVm.registerTapped()
    }
}

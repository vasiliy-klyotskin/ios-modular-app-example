//
//  Login+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

@testable import JustChat

extension LoginTests.Sut {
    func initiateLoginSubmit() {
        submit()
    }
    
    func changeLoginInput(_ value: String) {
        input.input = value
    }
    
    func simulateGoogleAuthTap() {
        googleAuthTapped()
    }
    
    func simulateRegisterTap() {
        registerTapped()
    }
    
    func initiateLoginWithValidInput() {
        changeLoginInput("any login")
        initiateLoginSubmit()
    }
}

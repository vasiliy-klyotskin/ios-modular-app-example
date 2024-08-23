//
//  RegisterFeature+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

@testable import JustChat

extension RegisterTests.Sut {
    func initiateRegistration() {
        submit()
    }
    
    func changeEmailInput(_ value: String) {
        email.input = value
    }
    
    func changeUsernameInput(_ value: String) {
        username.input = value
    }
    
    func simulateLoginTap() {
        loginTapped()
    }
    
    func initiateRegistrationWithValidEmailAndUsername() {
        changeEmailInput("any email")
        changeUsernameInput("any username")
        initiateRegistration()
    }
}

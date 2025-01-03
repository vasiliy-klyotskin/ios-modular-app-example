//
//  Login+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Primitives
import PrimitivesDSL
@testable import Authentication

extension LoginTests.Sut {
    func simulateUserInitiateLogin() {
        submit()
    }
    
    func simulateUserChangesLoginInput(_ value: String) {
        input.simulateChangingInput(value)
    }
    
    func simulateUserTapsGoogleAuth() {
        googleAuthTapped()
    }
    
    func simulateUserTapsRegister() {
        registerTapped()
    }
    
    func simulateUserInitiateLoginWithValidInput() {
        simulateUserChangesLoginInput("any login")
        simulateUserInitiateLogin()
    }
}

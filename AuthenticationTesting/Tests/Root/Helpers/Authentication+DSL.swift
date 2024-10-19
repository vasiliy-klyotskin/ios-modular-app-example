//
//  Authentication+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

@testable import Authentication

extension AuthenticationTests.Sut {
    func loginScreen() throws -> LoginFeature {
        if !path.isEmpty { throw ScreenIsNotVisible() }
        return root
    }
    
    func enterOtpScreen() throws -> EnterCodeFeature {
        if case let .enterCode(screen) = path.last {
            return screen.feature
        } else {
            throw ScreenIsNotVisible()
        }
    }
    
    func registerScreen() throws -> RegisterFeature {
        if case let .register(screen) = path.last {
            return screen.feature
        } else {
            throw ScreenIsNotVisible()
        }
    }
    
    func oAuth() throws -> OAuthFeature {
        if let googleOAuthFeature {
            return googleOAuthFeature
        } else {
            throw ScreenIsNotVisible()
        }
    }
}

struct ScreenIsNotVisible: Error {}

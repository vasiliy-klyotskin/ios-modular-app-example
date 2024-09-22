//
//  AuthenticationTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class AuthenticationTests {
    @Test
    func userLoginsWithOtp() throws {
        let (sut, spy) = makeSut()
        
        #expect(spy.storedAccessToken == nil, "There should not be an access token initially.")
        #expect(spy.storedRefreshToken == nil, "There should not be a refresh token initially.")
        #expect(spy.successMessages.count == 0, "There should not be success messages initially.")
        
        try sut.loginScreen().simulateUserChangesLoginInput("CrazyFrog123")
        try sut.loginScreen().simulateUserInitiateLogin()
        spy.finishRemoteWith(response: LoginData.successResponse(token: "any", otpLength: 4), index: 0)
        
        try sut.enterOtpScreen().simulateUserEntersOtp("1234")
        spy.finishRemoteWith(response: EnterCodeData.successSubmitResponse(
            accessToken: "access token 123",
            refreshToken: "refresh token 123"
        ), index: 1)
        
        #expect(spy.storedAccessToken == "access token 123", "There should be an access token after the flow finishes.")
        #expect(spy.storedRefreshToken == "refresh token 123", "There should be a refresh token after the flow finishes.")
        #expect(spy.successMessages == [.init(accessToken: "access token 123", refreshToken: "refresh token 123")], "There should be a success message after the flow finishes.")
    }
    
    @Test
    func userRegisters() throws {
        let (sut, spy) = makeSut()
        
        #expect(spy.storedAccessToken == nil, "There should not be an access token initially.")
        #expect(spy.storedRefreshToken == nil, "There should not be a refresh token initially.")
        #expect(spy.successMessages.count == 0, "There should not be success messages initially.")
        
        try sut.loginScreen().simulateUserTapsRegister()
        
        try sut.registerScreen().simulateUserChangesEmailInput("nofate@skynet.com")
        try sut.registerScreen().simulateUserChangesUsernameInput("JohnConnor")
        try sut.registerScreen().simulateUserInitiatesRegistration()
        spy.finishRemoteWith(response: LoginData.successResponse(token: "any", otpLength: 4), index: 0)
        
        try sut.enterOtpScreen().simulateUserEntersOtp("1234")
        spy.finishRemoteWith(response: EnterCodeData.successSubmitResponse(
            accessToken: "access token 321",
            refreshToken: "refresh token 321"
        ), index: 1)
        
        #expect(spy.storedAccessToken == "access token 321", "There should be an access token after the flow finishes.")
        #expect(spy.storedRefreshToken == "refresh token 321", "There should be a refresh token after the flow finishes.")
        #expect(spy.successMessages == [.init(accessToken: "access token 321", refreshToken: "refresh token 321")], "There should be a success message after the flow finishes.")
    }
    
    @Test
    func userSignsInWithGoogle() throws {
        let (sut, spy) = makeSut()
        
        #expect(spy.storedAccessToken == nil, "There should not be an access token initially.")
        #expect(spy.storedRefreshToken == nil, "There should not be a refresh token initially.")
        #expect(spy.successMessages.count == 0, "There should not be success messages initially.")
        
        try sut.loginScreen().simulateUserTapsGoogleAuth()
        
        spy.oAuth.finishWIth(url: OAuthData.redirectUrlWith(code: "abc123"))
        spy.finishRemoteWith(response: OAuthData.successResponse(accessToken: "access", refreshToken: "refresh"), index: 0)
        
        #expect(spy.storedAccessToken == "access", "There should be an access token after the flow finishes.")
        #expect(spy.storedRefreshToken == "refresh", "There should be a refresh token after the flow finishes.")
        #expect(spy.successMessages == [.init(accessToken: "access", refreshToken: "refresh")], "There should be a success message after the flow finishes.")
    }
    
    // MARK: - Helpers
    
    typealias Sut = AuthenticationFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, AuthenticationSpy) {
        let spy = AuthenticationSpy()
        let container = makeContainer(spy: spy)
        let env = AuthenticationEnvironment.from(resolver: container)
        let events = AuthenticationEvents(onSuccess: spy.processSuccess)
        let sut = AuthenticationFeature.make(env: env, events: events)
        leakChecker.addForChecking(sut, spy, spy.remote, spy.keychain, sourceLocation: loc)
        spy.clearPersistedValues()
        return (sut, spy)
    }
    
    private func makeContainer(spy: AuthenticationSpy) -> Container {
        Container()
            .register(RemoteClient.self, spy.remote.load)
            .register(AnySchedulerOf<DispatchQueue>.self, spy.uiScheduler.eraseToAnyScheduler())
            .register(ToastFeature.self, .init())
            .register(MakeTimer.self, spy.timer.make())
            .register(MakeAuthSession.self, spy.oAuth.makeSession)
            .register(KeychainStorage.self, spy.keychain)
            .register(AppInfo.self, .init())
    }
}

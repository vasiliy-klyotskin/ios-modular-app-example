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
        #expect(spy.successMessages == 0, "There should not be success messages initially.")
        
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
        #expect(spy.successMessages == 1, "There should be a success message after the flow finishes.")
    }
    
    @Test
    func userRegisters() throws {
        let (sut, spy) = makeSut()
        
        #expect(spy.storedAccessToken == nil, "There should not be an access token initially.")
        #expect(spy.storedRefreshToken == nil, "There should not be a refresh token initially.")
        #expect(spy.successMessages == 0, "There should not be success messages initially.")
        
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
        #expect(spy.successMessages == 1, "There should be a success message after the flow finishes.")
    }
    
    // MARK: - Helpers
    
    typealias Sut = AuthenticationFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, AuthenticationSpy) {
        let spy = AuthenticationSpy()
        let env = AuthenticationEnvironment(
            httpClient: spy.remote.load,
            scheduler: spy.scheduler.eraseToAnyScheduler(),
            makeTimer: spy.timer.make(),
            storage: spy.storage
        )
        let events = AuthenticationEvents(onSuccess: spy.processSuccess)
        let sut = AuthenticationFeature.make(env: env, events: events)
        leakChecker.addForChecking(sut, spy, spy.remote, spy.storage, sourceLocation: loc)
        spy.clearPersistedValues()
        return (sut, spy)
    }
}

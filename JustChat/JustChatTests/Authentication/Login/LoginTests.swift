//
//  LoginTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class LoginTests {
    @Test func submitRequest() {
        let (sut, spy) = makeSut()
        
        #expect(spy.remote.requests.isEmpty, "There should be no requests initially.")
        
        sut.simulateUserChangesLoginInput("any login")
        #expect(spy.remote.requests.isEmpty, "There should be no requests after the user changes the login input.")
        
        sut.simulateUserInitiateLogin()
        expectRequestIsCorrect(spy.remote.requests[0], for: "any login", "A remote request should be made after the user submits.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving an error.")
        
        sut.simulateUserChangesLoginInput("new login")
        sut.simulateUserInitiateLogin()
        expectRequestIsCorrect(spy.remote.requests[1], for: "new login", "A remote request should be made after user resubmits.")
        
        spy.remote.finishWith(response: successResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.remote.requests.count == 2, "There should be no new requests after success.")
    }
    
    @Test func loadingIndicator() {
        let (sut, spy) = makeSut()
        
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false initially.")
        
        sut.simulateUserChangesLoginInput("any")
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after the user edits input.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.isLoadingIndicatorDisplayed == true, "The loading state should be true after the user submits.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after receiving an error.")
        
        sut.simulateUserInitiateLogin()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after success.")
    }
    
    @Test func generalError() {
        let (sut, spy) = makeSut()
        
        #expect(spy.generalError == nil, "There should be no general error initially.")
        
        sut.simulateUserChangesLoginInput("any")
        sut.simulateUserInitiateLogin()
        #expect(spy.generalError == nil, "There should be no general error after the user submits.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a system general error after the request fails.")
        
        sut.simulateUserChangesLoginInput("new login")
        #expect(spy.generalError == RemoteStrings.values.system, "General error should persist after the user changes login.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.generalError == nil, "There should be no general error after the user resubmits.")
        
        spy.finishRemoteWith(response: generalError("error message"), index: 1)
        #expect(spy.generalError == "error message", "There should be a general error after the user receives a remote general error.")
    }
    
    @Test func validationError() {
        let (sut, spy) = makeSut()
        
        #expect(spy.loginError == nil, "There should be no login input error initially.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.loginError == LoginStrings.emptyInputError, "There should be an empty login error after the user submits if input is empty.")
        
        sut.simulateUserChangesLoginInput("any")
        #expect(spy.loginError == nil, "There should be no login input error after the user changes the login.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.loginError == nil, "There should be no login input error after the user submits.")
        
        spy.finishRemoteWith(response: inputError("login error"), index: 0)
        #expect(spy.loginError == "login error", "There should be a login input error after receiving an error.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.loginError == nil, "There should be no login input error after the user resubmits.")
    }
    
    @Test func contentIsDisabled() {
        let (sut, spy) = makeSut()
        
        #expect(spy.isContentDisabled == false, "Content should not be disabled initially.")
        
        sut.simulateUserChangesLoginInput("any")
        #expect(spy.isContentDisabled == false, "Content should not be disabled after the user changes an input.")
        
        sut.simulateUserInitiateLogin()
        #expect(spy.isContentDisabled == true, "Content should be disabled after the user submits.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isContentDisabled == false, "Content should not be disabled after receiving an error.")
        
        sut.simulateUserInitiateLogin()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.isContentDisabled == false, "Content should not be disabled after success.")
    }
    
    @Test func loginInput() {
        let (sut, spy) = makeSut()
        
        sut.simulateUserChangesLoginInput("login")
        sut.simulateUserInitiateLogin()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 0)
        #expect(spy.input == "login", "Input should not be cleared after success")
    }
    
    @Test func successMessage() {
        let (sut, spy) = makeSut()
        
        #expect(spy.successes.isEmpty, "There should not be a success message initially.")
        
        sut.simulateUserChangesLoginInput("login")
        sut.simulateUserInitiateLogin()
        #expect(spy.successes.isEmpty, "There should not be a success message after the user submits.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.successes.isEmpty, "There should not be a success message after receiving an error.")
        
        sut.simulateUserInitiateLogin()
        spy.finishRemoteWith(response: successResponse(token: "token", otpLength: 4, next: 30), index: 1)
        #expect(spy.successes == [successModel(token: "token", otpLength: 4, nextAttemptAfter: 30)], "There should be a success message after receiving an error.")
    }

    @Test func googleOauthTap() {
        let (sut, spy) = makeSut()
        #expect(spy.googleAuthCalls == 0)

        sut.simulateUserTapsGoogleAuth()
        #expect(spy.googleAuthCalls == 1)
    }
    
    @Test func registerTap() {
        let (sut, spy) = makeSut()
        #expect(spy.regiterCalls == 0)
        
        sut.simulateUserTapsRegister()
        #expect(spy.regiterCalls == 1)
    }
    
    @Test func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.simulateUserInitiateLoginWithValidInput()
    }
    
    // MARK: - Helpers
    
    typealias Sut = LoginFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, LoginFeatureSpy) {
        let spy = LoginFeatureSpy()
        let env = LoginEnvironment(httpClient: spy.remote.load, scheduler: spy.scheduler.eraseToAnyScheduler())
        let events = LoginEvents(
            onSuccessfulSubmitLogin: spy.keepLoginModel(_:),
            onGoogleOAuthButtonTapped: spy.incrementGoogleAuth,
            onRegisterButtonTapped: spy.incrementRegister
        )
        let sut = LoginFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

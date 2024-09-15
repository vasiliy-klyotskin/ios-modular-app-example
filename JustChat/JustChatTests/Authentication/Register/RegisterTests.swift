//
//  RegisterFeatureTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class RegisterTests {
    @Test func registrationRequest() {
        let (sut, spy) = makeSut()
        
        #expect(spy.remote.requests.isEmpty, "There should be no requests initially.")
        
        sut.simulateUserChangesEmailInput("email")
        sut.simulateUserChangesUsernameInput("username")
        #expect(spy.remote.requests.isEmpty, "There should be no requests after the user enters credentials.")
        
        sut.simulateUserInitiatesRegistration()
        expectRequestIsCorrect(spy.remote.requests[0], for: "email", username: "username", "A remote request should be made after the user initiates registration.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving an error.")
        
        sut.simulateUserChangesEmailInput("new email")
        sut.simulateUserChangesUsernameInput("new username")
        sut.simulateUserInitiatesRegistration()
        expectRequestIsCorrect(spy.remote.requests[1], for: "new email", username: "new username", "A remote request should be made after the user initiates registration with new credentials.")
        
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.remote.requests.count == 2, "There should be no new requests after receiving success.")
    }
    
    @Test func loadingIndicator() {
        let (sut, spy) = makeSut()
        
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false initially.")
        
        sut.simulateUserEntersAnyCredentials()
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after the user enters credentials.")
        
        sut.simulateUserInitiatesRegistration()
        #expect(spy.isLoadingIndicatorDisplayed == true, "The loading state should be true after the user initiates registration.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after receiving an error.")
        
        sut.simulateUserInitiatesRegistration()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.isLoadingIndicatorDisplayed == false, "The loading state should be false after receiving success.")
    }
    
    @Test func emptyInputValidationErrors() {
        let (sut, spy) = makeSut()
        
        #expect(spy.emailError == nil, "There should be no email input error initially.")
        #expect(spy.usernameError == nil, "There should be no username input error initially.")
        
        sut.simulateUserInitiatesRegistration()
        #expect(spy.emailError == RegisterStrings.emptyEmailError, "There should be an email empty input error after the user initiates registration.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "There should be a username empty input error after the user initiates registration.")
        
        sut.simulateUserChangesEmailInput("new email")
        sut.simulateUserChangesUsernameInput("new username")
        #expect(spy.emailError == nil, "There should be no email input error after the user changes email input.")
        #expect(spy.usernameError == nil, "There should be no username input error after the user changes username.")
    }
    
    @Test func remoteInputValidationErrors() {
        let (sut, spy) = makeSut()
        
        sut.simulateUserInitiatesRegistrationWithValidEmailAndUsername()
        #expect(spy.emailError == nil, "There should be no email input error after the user initiates registration.")
        #expect(spy.usernameError == nil, "There should be no username input error after the user initiates registration.")
        
        spy.finishRemoteWith(response: TestData.validationErrorResponse(email: "email error", username: "username error"), index: 0)
        #expect(spy.emailError == "email error", "There should be an email input error after receiving a validation error.")
        #expect(spy.usernameError == "username error", "There should be an username input error after receiving a validation error.")
    }
    
    @Test func generalError() {
        let (sut, spy) = makeSut()
        
        #expect(spy.generalError == nil, "There should be no general error initially.")
        
        sut.simulateUserInitiatesRegistrationWithValidEmailAndUsername()
        #expect(spy.generalError == nil, "There should be no general error after the user initiates registration.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a general error after the request fails.")
        
        sut.simulateUserInitiatesRegistration()
        #expect(spy.generalError == nil, "There should be no general error after the user initiates registration again.")
        
        spy.finishRemoteWith(response: TestData.generalErrorResponse(message: "general error"), index: 1)
        #expect(spy.generalError == "general error", "There should be a general error after receiving general error.")
        
        sut.simulateUserInitiatesRegistration()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 4), index: 2)
        #expect(spy.generalError == nil, "There should be no general error after receiving success.")
    }
    
    @Test func contentIsDisabled() {
        let (sut, spy) = makeSut()
        
        #expect(spy.isContentDisabled == false, "Content should not be disabled initially.")
        
        sut.simulateUserInitiatesRegistrationWithValidEmailAndUsername()
        #expect(spy.isContentDisabled == true, "Content should be disabled after the user initiates registration.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isContentDisabled == false, "Content should not be disabled after the request fails.")
        
        sut.simulateUserInitiatesRegistration()
        spy.finishRemoteWith(response: successResponse(token: "any", otpLength: 0), index: 1)
        #expect(spy.isContentDisabled == false, "Content should not be disabled after success.")
    }
    
    @Test func successMessage() {
        let (sut, spy) = makeSut()
        
        #expect(spy.successes.isEmpty, "There should not be a success message initially.")
        
        sut.simulateUserInitiatesRegistrationWithValidEmailAndUsername()
        #expect(spy.successes.isEmpty, "There should not be a success message after the user initiates registration.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.successes.isEmpty, "There should not be a success message after the request fails.")
        
        sut.simulateUserInitiatesRegistration()
        spy.finishRemoteWith(response: successResponse(token: "token", otpLength: 4, next: 30), index: 1)
        #expect(spy.successes == [TestData.successModel(token: "token", otpLength: 4, nextAttemptAfter: 30)], "There should be a message after receiving success.")
    }
    
    @Test func loginButtonTap() {
        let (sut, spy) = makeSut()
        #expect(spy.loginCalls == 0)

        sut.simulateUserTapsLogin()
        #expect(spy.loginCalls == 1)
    }
    
    @Test func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.simulateUserInitiatesRegistrationWithValidEmailAndUsername()
    }
    
    // MARK: - Helpers
    
    typealias Sut = RegisterFeature
    typealias TestData = RegisterData
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, RegisterFeatureSpy) {
        let spy = RegisterFeatureSpy()
        let env = RegisterEnvironment(httpClient: spy.remote.load, scheduler: spy.scheduler.eraseToAnyScheduler())
        let events = RegisterEvents(
            onSuccessfulSubmitRegister: spy.keepRegisterModel(_:),
            onLoginButtonTapped: spy.incrementLoginCalls
        )
        let sut = RegisterFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, spy.remote, sourceLocation: loc)
        return (sut, spy)
    }
}

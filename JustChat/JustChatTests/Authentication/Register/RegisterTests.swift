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
    @Test func happyPath() {
        let (sut, spy) = makeSut()
        
        // MARK: When the scenario starts
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user changes email and username input to valid ones
        sut.changeEmailInput("any email")
        sut.changeUsernameInput("any username")
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits valid email and username
        sut.initiateRegistration()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[0], for: "any email", username: "any username", "A remote request should be made.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request finishes successfully
        spy.finishRemoteRequestWith(response: apiSuccessResponse(token: "token", otpLength: 5, next: 120), index: 0)
        let expectedSuccess = successModel(email: "any email", username: "any username", token: "token", otpLength: 5, nextAttemptAfter: 120)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes == [expectedSuccess], "There should be a success message.")
    }
    
    @Test func validationErrors() {
        let (sut, spy) = makeSut()
        sut.initiateRegistrationWithValidEmailAndUsername()
        
        // MARK: When the request finishes with email and username validation errors
        spy.finishRemoteRequestWith(response: apiValidationErrorResponse(email: "email error", username: "username error"), index: 0)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.emailError == "email error", "The email validation error message should be shown.")
        #expect(spy.usernameError == "username error", "The username validation error message should be shown.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user initiates registration again at once
        sut.initiateRegistration()
        #expect(spy.isLoading == true, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be a new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user modifies email after validation error
        spy.finishRemoteRequestWith(response: apiValidationErrorResponse(email: "email error", username: "username error"), index: 1)
        sut.changeEmailInput("any new email")
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == "username error", "The username validation error message should be shown.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")

        // MARK: When the user modifies username
        sut.changeUsernameInput("any new usernmae")
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
    }
    
    @Test func generalError() {
        let (sut, spy) = makeSut()
        sut.initiateRegistrationWithValidEmailAndUsername()
        
        // MARK: When the request fails
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == RemoteStrings.values.system, "A general error message should be shown.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits again
        sut.initiateRegistration()
        #expect(spy.isLoading == true, "The loading state should be true.")
        #expect(spy.requests.count == 2, "There should be a new request.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request finishes with remote general error
        spy.finishRemoteRequestWith(response: apiGeneralErrorResponse(message: "general error"), index: 1)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == "general error", "A general error message should be shown.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
    }
    
    @Test func emptyInputErrors() {
        let (sut, spy) = makeSut()
        
        // MARK: When the user submits an empty empty email and username
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == RegisterStrings.emptyEmailError, "An empty email input error message should be shown.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "An empty username input error message should be shown.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.requests.count == 0, "There should be no new requests.")
        
        // MARK: When the user enters email and submits again
        sut.changeEmailInput("any email")
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "An empty username input error message should be shown.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.requests.count == 0, "There should be no new requests.")
        
        // MARK: When the user enters email and submits again
        sut.changeUsernameInput("any username")
        sut.submit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "An empty username input error message should be shown.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.requests.count == 1, "There should be a new request.")
    }
    
    @Test func tapEvents() {
        let (sut, spy) = makeSut()
        #expect(spy.loginCalls == 0)

        sut.simulateLoginTap()
        #expect(spy.loginCalls == 1)
    }
    
    @Test func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.initiateRegistrationWithValidEmailAndUsername()
    }
    
    typealias Sut = RegisterFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, RegisterFeatureSpy) {
        let spy = RegisterFeatureSpy()
        let env = RegisterEnvironment(httpClient: spy.remote, scheduler: DispatchQueue.test.eraseToAnyScheduler())
        let events = RegisterEvents(
            onSuccessfulSubmitRegister: spy.keepRegisterModel(_:),
            onLoginButtonTapped: spy.incrementLoginCalls
        )
        let sut = RegisterFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

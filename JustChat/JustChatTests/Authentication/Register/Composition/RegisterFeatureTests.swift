//
//  RegisterFeatureTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite
final class RegisterFeatureTests {
    @Test
    func sutPerformsInitialSubmitScenario() {
        let (sut, spy) = makeSut()
        
        // MARK: When the scenario starts
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits an empty login
        sut.initiateRegistration()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.emailError == RegisterStrings.emptyEmailError, "An empty email input error message should be shown.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "An empty username input error message should be shown.")
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
        
        // MARK: When the request finishes with email input error
        spy.finishRemoteRequestWith(response: apiErrorResponse(email: "email error", username: "username error"), index: 0)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.emailError == "email error", "The email validation error message should be shown.")
        #expect(spy.usernameError == "username error", "The username validation error message should be shown.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
    
        // MARK: When the user changes email and username to another ones
        sut.changeEmailInput("another email")
        sut.changeUsernameInput("another username")
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits again
        sut.initiateRegistration()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[1], for: "another email", username: "another username", "A new remote request should be made.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request fails
        spy.finishRemoteRequestWithError(index: 1)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == RemoteStrings.values.system, "A general error message should be shown.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits again
        sut.initiateRegistration()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[2], for: "another email", username: "another username", "A new remote request should be made.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request finishes successfully
        spy.finishRemoteRequestWith(response: apiSuccessResponse(token: "token", otpLength: 5, next: 120), index: 2)
        let expectedSuccess = successModel(email: "another email", username: "another username", token: "token", otpLength: 5, nextAttemptAfter: 120)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 3, "There should be no new requests.")
        #expect(spy.emailError == nil, "There should be no email input error.")
        #expect(spy.usernameError == nil, "There should be no username input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes == [expectedSuccess], "There should be a success message.")
    }
    
    @Test
    func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.changeEmailInput("any")
        sut.changeUsernameInput("any")
        sut.initiateRegistration()
    }
    
    typealias Sut = RegisterFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, RegisterFeatureSpy) {
        let spy = RegisterFeatureSpy()
        let env = RegisterEnvironment(httpClient: spy.remote, scheduler: DispatchQueue.test.eraseToAnyScheduler())
        let events = RegisterEvents(
            onSuccessfulSubmitRegister: spy.keepRegisterModel(_:),
            onLoginButtonTapped: {}
        )
        let sut = RegisterFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut.emailInputVm, sut.emailInputVm, sut.registerVm, sut.toastVm, spy)
        return (sut, spy)
    }
}

//
//  LoginTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite
final class LoginFeatureTests {
    @Test
    func sutPerformsInitialSubmitScenario() {
        let (sut, spy) = makeSut()
        
        // MARK: When the scenario starts
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits an empty login
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.inputError == LoginStrings.emptyInputError, "An empty input error message should be shown.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user changes login input to a valid one
        sut.changeLoginInput("any login")
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.requests.isEmpty, "There should be no requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits a valid login
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[0], for: "any login", "A remote request should be made.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request finishes with input error
        spy.finishRemoteRequestWith(response: inputError("input error"), index: 0)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.inputError == "input error", "The validation error message should be shown.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")

        // MARK: When the user changes login to another one
        sut.changeLoginInput("another login")
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits another login
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[1], for: "another login", "A new remote request should be made.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request fails
        spy.finishRemoteRequestWithError(index: 1)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 2, "There should be no new requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == RemoteStrings.values.system, "A general error message should be shown.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the user submits again
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[2], for: "another login", "A new remote request should be made.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "The general error should be hidden.")
        #expect(spy.successes.isEmpty, "There should be no success messages.")
        
        // MARK: When the request finishes successfully
        spy.finishRemoteRequestWith(response: successResponse(token: "token", otpLength: 5, next: 120), index: 2)
        let expectedSuccess = successModel(login: "another login", token: "token", otpLength: 5, nextAttemptAfter: 120)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 3, "There should be no new requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes == [expectedSuccess], "There should be a success message.")
    }
    
    @Test
    func sutPerformsRepeatedSubmitScenario() {
        let (sut, spy) = makeSut()
        
        // MARK: When the user submits the same login and the cache is not expired yet
        sut.changeLoginInput("my login")
        sut.initiateLoginSubmit()
        spy.finishRemoteRequestWith(response: successResponse(token: "token 1", otpLength: 4, next: 60), index: 0)
        spy.simulateTimePassed(seconds: 59)
        sut.initiateLoginSubmit()
        let expectedSuccess1 = successModel(login: "my login", token: "token 1", otpLength: 4, nextAttemptAfter: 1)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.requests.count == 1, "There should be no new requests.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.last == expectedSuccess1, "The last success message should match the expected success.")

        // MARK: When the user submits the same login and the cache is already expired
        spy.simulateTimePassed(seconds: 1)
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        #expect(spy.requests.count == 2, "There should be a new request.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 2, "There should be no new success messages.")

        // MARK: When the user submits another login and the cache for the previous login is not expired yet
        spy.finishRemoteRequestWith(response: successResponse(token: "token 2", otpLength: 8, next: 100), index: 1)
        sut.changeLoginInput("another login")
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestIsCorrect(spy.requests[2], for: "another login", "There should be a new request.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 3, "There should be no new success messages after submission.")

        // MARK: When the request with another login succeeds and the user tries to submit the initial login again after some time
        spy.finishRemoteRequestWith(response: successResponse(token: "token 3", otpLength: 9, next: 90), index: 2)
        sut.changeLoginInput("my login")
        spy.simulateTimePassed(seconds: 5)
        sut.initiateLoginSubmit()
        let expectedSuccess2 = successModel(login: "my login", token: "token 2", otpLength: 8, nextAttemptAfter: 95)
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 5, "There should be one new success message after submission.")
        #expect(spy.successes.last == expectedSuccess2, "The last success message should match the expected success.")
        
        // MARK: When the request for yet another login fails and the user tries to submit the initial login again
        sut.changeLoginInput("yet another login")
        sut.initiateLoginSubmit()
        spy.finishRemoteRequestWithError(index: 3)
        sut.changeLoginInput("my login")
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 6, "There should be one new success message after submission.")
        
        // MARK: When receive input error for yet another login and the user tries to submit the initial login again
        sut.changeLoginInput("yet another login")
        sut.initiateLoginSubmit()
        spy.finishRemoteRequestWith(response: inputError("any error"), index: 4)
        sut.changeLoginInput("my login")
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 7, "There should be one new success message after submission.")
    }
    
    @Test
    func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.changeLoginInput("any")
        sut.initiateLoginSubmit()
    }
    
    typealias Sut = LoginFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, LoginFeatureSpy) {
        let spy = LoginFeatureSpy()
        let env = LoginEnvironment(
            httpClient: spy.remote,
            currentTime: spy.getCurrentTime,
            scheduler: DispatchQueue.test.eraseToAnyScheduler()
        )
        let events = LoginEvents(
            onSuccessfulSubmitLogin: spy.keepLoginModel(_:),
            onGoogleOAuthButtonTapped: {},
            onRegisterButtonTapped: {}
        )
        let sut = LoginFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut.inputVm)
        leakChecker.addForChecking(sut.submitVm)
        leakChecker.addForChecking(sut.toastVm)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
}

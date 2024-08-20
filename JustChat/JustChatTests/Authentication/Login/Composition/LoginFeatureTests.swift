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
    func sutDealocatesWhenRequestIsInProgress() {
        let (sut, _) = makeSut()
        sut.changeLoginInput("any")
        sut.initiateLoginSubmit()
    }
    
    typealias Sut = LoginFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, LoginFeatureSpy) {
        let spy = LoginFeatureSpy()
        let env = LoginEnvironment(httpClient: spy.remote)
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

//
//  EnterCodeTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class EnterCodeTests {
//    @Test func happyPath() {
//        let (sut, spy) = makeSut()
//        
//        // MARK: When the scenario starts
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.isEmpty, "There should be no requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the user changes login input to a valid one
//        sut.changeLoginInput("any login")
//        #expect(spy.isLoading == false, "The loading state should remain false.")
//        #expect(spy.requests.isEmpty, "There should be no requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the user submits a valid login
//        sut.initiateLoginSubmit()
//        #expect(spy.isLoading == true, "The loading state should be true.")
//        expectRequestIsCorrect(spy.requests[0], for: "any login", "A remote request should be made.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the request finishes successfully
//        spy.finishRemoteRequestWith(response: successResponse(token: "token", otpLength: 5, next: 120), index: 0)
//        let expectedSuccess = successModel(login: "any login", token: "token", otpLength: 5, nextAttemptAfter: 120)
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.count == 1, "There should be no new requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes == [expectedSuccess], "There should be a success message.")
//    }
//    
//    @Test func validationError() {
//        let (sut, spy) = makeSut()
//        sut.initiateLoginWithValidInput()
//        
//        // MARK: When the request finishes with login input error
//        spy.finishRemoteRequestWith(response: inputError("login error"), index: 0)
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.count == 1, "There should be no new requests.")
//        #expect(spy.loginError == "login error", "The validation error message should be shown.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the user initiates login again at once
//        sut.initiateLoginSubmit()
//        #expect(spy.isLoading == true, "The loading state should be true.")
//        #expect(spy.requests.count == 2, "There should be a new request.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the user modifies login after another validation error
//        spy.finishRemoteRequestWith(response: inputError("login error"), index: 1)
//        sut.changeLoginInput("another login")
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.count == 2, "There should be no new requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//    }
//    
//    @Test func generalError() {
//        let (sut, spy) = makeSut()
//        sut.initiateLoginWithValidInput()
//        
//        // MARK: When the request fails
//        spy.finishRemoteRequestWithError(index: 0)
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.count == 1, "There should be no new requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == RemoteStrings.values.system, "A general error message should be shown.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the user initiates login again at once
//        sut.initiateLoginSubmit()
//        #expect(spy.isLoading == true, "The loading state should be true.")
//        #expect(spy.requests.count == 2, "There should be a new request.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//        
//        // MARK: When the request fails with remote general error
//        spy.finishRemoteRequestWith(response: generalError("general error"), index: 1)
//        #expect(spy.isLoading == false, "The loading state should be false.")
//        #expect(spy.requests.count == 2, "There should be no new requests.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == "general error", "A general error message should be shown.")
//        #expect(spy.successes.isEmpty, "There should be no success messages.")
//    }
//    
//    @Test func emptyInputError() {
//        let (sut, spy) = makeSut()
//        
//        // MARK: When the user submits an empty login
//        sut.initiateLoginSubmit()
//        #expect(spy.isLoading == false, "The loading state should remain false.")
//        #expect(spy.requests.isEmpty, "There should be no requests.")
//        #expect(spy.loginError == LoginStrings.emptyInputError, "An empty login input error message should be shown.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//        
//        // MARK: When the user submits a not empty login
//        sut.changeLoginInput("any")
//        sut.initiateLoginSubmit()
//        #expect(spy.isLoading == true, "The loading state should be true.")
//        #expect(spy.requests.count == 1, "There should be a new request.")
//        #expect(spy.loginError == nil, "There should be no login input error.")
//        #expect(spy.generalError == nil, "There should be no general error.")
//    }
//    
//    @Test func tapEvents() {
//        let (sut, spy) = makeSut()
//        #expect(spy.googleAuthCalls == 0)
//        #expect(spy.regiterCalls == 0)
//        
//        sut.simulateRegisterTap()
//        #expect(spy.googleAuthCalls == 0)
//        #expect(spy.regiterCalls == 1)
//        
//        sut.simulateGoogleAuthTap()
//        #expect(spy.googleAuthCalls == 1)
//        #expect(spy.regiterCalls == 1)
//    }
//    
//    @Test func sutDealocatesWhenRequestIsInProgress() {
//        let (sut, _) = makeSut()
//        sut.initiateLoginWithValidInput()
//    }
    
    typealias Sut = EnterCodeFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, EnterCodeFeatureSpy) {
        let spy = EnterCodeFeatureSpy()
        let env = EnterCodeEnvironment(httpClient: spy.remote, scheduler: DispatchQueue.test.eraseToAnyScheduler())
        let events = EnterCodeEvents(onCorrectOtpEnter: spy.keepSuccess)
        let sut = EnterCodeFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

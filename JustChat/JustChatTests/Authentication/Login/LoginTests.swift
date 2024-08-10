//
//  LoginTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Testing
import JustChat
import Foundation

@Suite
struct LoginTests {
    @Test
    func sutPerformsInitialSubmitScenario() {
        let (sut, spy) = makeSut()
        
        // Assert initial state
        #expect(spy.isLoading == false, "The loading state should be false initially.")
        #expect(spy.requests.isEmpty, "There should be no requests initially.")
        #expect(spy.inputError == nil, "There should be no input error initially.")
        #expect(spy.generalError == nil, "There should be no general error initially.")
        #expect(spy.successes.isEmpty, "There should be no success messages initially.")
        
        // Perform an empty login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should remain false after submitting an empty login.")
        #expect(spy.requests.isEmpty, "There should be no requests after submitting an empty login.")
        #expect(spy.inputError == LoginStrings.emptyInputError, "An empty input error message should be shown after submitting an empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting an empty login.")
        #expect(spy.successes.isEmpty, "There should be no success messages after submitting an empty login.")
        
        // Change login input to a valid one and assert state
        sut.changeLoginInput("any login")
        #expect(spy.isLoading == false, "The loading state should remain false after changing the login input.")
        #expect(spy.requests.isEmpty, "There should be no requests after changing the login input.")
        #expect(spy.inputError == nil, "There should be no input error after changing the login input.")
        #expect(spy.generalError == nil, "There should be no general error after changing the login input.")
        #expect(spy.successes.isEmpty, "There should be no success messages after changing the login input.")
        
        // Perform a valid login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting a non-empty login.")
        expectRequestCorrect(spy.requests[0], for: "any login", "A remote request should be made after submitting a non-empty login.")
        #expect(spy.inputError == nil, "There should be no input error after submitting a non-empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting a non-empty login.")
        #expect(spy.successes.isEmpty, "There should be no success messages after submitting a non-empty login.")
        
        // Handle input error from remote and assert state
        spy.finishRemoteRequestWith(response: input(error: "input error"), index: 0)
        #expect(spy.isLoading == false, "The loading state should be false after receiving an input error.")
        #expect(spy.requests.count == 1, "There should be no new requests after receiving an input error.")
        #expect(spy.inputError == "input error", "The validation error message should be shown after receiving an input error.")
        #expect(spy.generalError == nil, "There should be no general error after receiving an input error.")
        #expect(spy.successes.isEmpty, "There should be no success messages after receiving an input error.")

        // Change login input to another valid one and assert state
        sut.changeLoginInput("another login")
        #expect(spy.isLoading == false, "The loading state should be false after changing the login input again.")
        #expect(spy.requests.count == 1, "There should be no new requests after changing the login input again.")
        #expect(spy.inputError == nil, "There should be no input error after changing the login input again.")
        #expect(spy.generalError == nil, "There should be no general error after changing the login input again.")
        #expect(spy.successes.isEmpty, "There should be no success messages after changing the login input again.")
        
        // Perform another valid login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting another non-empty login.")
        expectRequestCorrect(spy.requests[1], for: "another login", "A new remote request should be made after submitting another login.")
        #expect(spy.inputError == nil, "There should be no input error after submitting another non-empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting another non-empty login.")
        #expect(spy.successes.isEmpty, "There should be no success messages after submitting another non-empty login.")
        
        // Handle general error from remote and assert state
        spy.finishRemoteRequestWithError(index: 1)
        #expect(spy.isLoading == false, "The loading state should be false after a request failure.")
        #expect(spy.requests.count == 2, "There should be no new requests after a request failure.")
        #expect(spy.inputError == nil, "There should be no input error after a request failure.")
        #expect(spy.generalError == "Something went wrong...", "A general error message should be shown after a request failure.")
        #expect(spy.successes.isEmpty, "There should be no success messages after after a request failure.")
        
        // Perform final login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting again.")
        expectRequestCorrect(spy.requests[2], for: "another login", "A new remote request should be made after submitting again.")
        #expect(spy.inputError == nil, "There should be no input error after submitting again.")
        #expect(spy.generalError == nil, "The general error should be hidden after submitting again.")
        #expect(spy.successes.isEmpty, "There should be no success messages after submitting again.")
        
        // Handle successful response and assert state
        spy.finishRemoteRequestWith(response: success(token: "token", otpLength: 5, next: 120), index: 2)
        let expectedSuccess = successModel(login: "another login", token: "token", otpLength: 5, nextAttemptAfter: 120)
        #expect(spy.isLoading == false, "The loading state should be false after a request success.")
        #expect(spy.requests.count == 3, "There should be no new requests after a request success.")
        #expect(spy.inputError == nil, "There should be no input error after a request success.")
        #expect(spy.generalError == nil, "There should be no general error after a request success.")
        #expect(spy.successes == [expectedSuccess], "There should be a success message after a request success")
    }
    
    @Test
    func sutPerformsRepeatedSubmitScenario() {
        let (sut, spy) = makeSut()
        
        // MARK: When the user submits the same login and the cache is not expired yet
        sut.changeLoginInput("my login")
        sut.initiateLoginSubmit()
        spy.finishRemoteRequestWith(response: success(token: "token 1", otpLength: 4, next: 60), index: 0)
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
        spy.finishRemoteRequestWith(response: success(token: "token 2", otpLength: 8, next: 100), index: 1)
        sut.changeLoginInput("another login")
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true.")
        expectRequestCorrect(spy.requests[2], for: "another login", "There should be a new request.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 3, "There should be no new success messages after submission.")

        // MARK: When the request with another login succeeds and the user tries to submit the initial login again after some time
        spy.finishRemoteRequestWith(response: success(token: "token 3", otpLength: 9, next: 90), index: 2)
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
        spy.finishRemoteRequestWith(response: input(error: "any error"), index: 4)
        sut.changeLoginInput("my login")
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.successes.count == 7, "There should be one new success message after submission.")
    }
    
    private func expectRequestCorrect(_ request: URLRequest, for login: String, _ comment: Comment?) {
        #expect(request.url?.absoluteString == "https://justchat.com/api/v1/login", comment)
        #expect(request.allHTTPHeaderFields == ["Content-Type": "application/json"], comment)
        #expect(request.httpMethod == "POST", comment)
        #expect(request.httpBody == body(for: login), comment)
    }
    
    private func body(for login: String) -> Data {
        "{\"login\":\"\(login)\"}".data(using: .utf8)!
    }
    
    private func success(token: String, otpLength: Int, next: Int = 60) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """.data(using: .utf8)!
        return (data, response)
    }
                
    private func successModel(login: String = "", token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> LoginModel {
        .init(login: login, confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
    
    private func input(error: String) -> (Data, HTTPURLResponse) {
        let non2xx = 400
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: non2xx, httpVersion: nil, headerFields: nil)!
        let data = """
            {
                "messages": {
                    "LOGIN_INPUT": "\(error)"
                }
            }
        """.data(using: .utf8)!
        return (data, response)
    }
    
    typealias Sut = LoginFeature
    
    private func makeSut() -> (Sut, LoginSpy) {
        let spy = LoginSpy()
        let sut = LoginComposer.make(
            remote: spy.remote,
            onReadyForOtpStep: spy.keepLoginModel,
            currentTime: spy.getCurrentTime
        )
        spy.startSpying(sut: sut)
        return (sut, spy)
    }
}

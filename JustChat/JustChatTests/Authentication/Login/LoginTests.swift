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
        
        // Perform an empty login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "The loading state should remain false after submitting an empty login.")
        #expect(spy.requests.isEmpty, "There should be no requests after submitting an empty login.")
        #expect(spy.inputError == LoginStrings.emptyInputError, "An empty input error message should be shown after submitting an empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting an empty login.")
        
        // Change login input to a valid one and assert state
        sut.changeLoginInput("any login")
        #expect(spy.isLoading == false, "The loading state should remain false after changing the login input.")
        #expect(spy.requests.isEmpty, "There should be no requests after changing the login input.")
        #expect(spy.inputError == nil, "There should be no input error after changing the login input.")
        #expect(spy.generalError == nil, "There should be no general error after changing the login input.")
        
        // Perform a valid login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting a non-empty login.")
        expectRequestCorrect(spy.requests[0], for: "any login", "A remote request should be made after submitting a non-empty login.")
        #expect(spy.inputError == nil, "There should be no input error after submitting a non-empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting a non-empty login.")
        
        // Handle input error from remote and assert state
        spy.finishRemoteRequestWith(response: input(error: "input error"), index: 0)
        #expect(spy.isLoading == false, "The loading state should be false after receiving an input error.")
        #expect(spy.requests.count == 1, "There should be no new requests after receiving an input error.")
        #expect(spy.inputError == "input error", "The validation error message should be shown after receiving an input error.")
        #expect(spy.generalError == nil, "There should be no general error after receiving an input error.")

        // Change login input to another valid one and assert state
        sut.changeLoginInput("another login")
        #expect(spy.isLoading == false, "The loading state should be false after changing the login input again.")
        #expect(spy.requests.count == 1, "There should be no new requests after changing the login input again.")
        #expect(spy.inputError == nil, "There should be no input error after changing the login input again.")
        #expect(spy.generalError == nil, "There should be no general error after changing the login input again.")
        
        // Perform another valid login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting another non-empty login.")
        expectRequestCorrect(spy.requests[1], for: "another login", "A new remote request should be made after submitting another login.")
        #expect(spy.inputError == nil, "There should be no input error after submitting another non-empty login.")
        #expect(spy.generalError == nil, "There should be no general error after submitting another non-empty login.")
        
        // Handle general error from remote and assert state
        spy.finishRemoteRequestWithError(index: 1)
        #expect(spy.isLoading == false, "The loading state should be false after a request failure.")
        #expect(spy.requests.count == 2, "There should be no new requests after a request failure.")
        #expect(spy.inputError == nil, "There should be no input error after a request failure.")
        #expect(spy.generalError == "Something went wrong...", "A general error message should be shown after a request failure.")
        
        // Perform final login submit and assert state
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "The loading state should be true after submitting again.")
        expectRequestCorrect(spy.requests[2], for: "another login", "A new remote request should be made after submitting again.")
        #expect(spy.inputError == nil, "There should be no input error after submitting again.")
        #expect(spy.generalError == nil, "The general error should be hidden after submitting again.")
        
        // Handle successful response and assert state
        spy.finishRemoteRequestWith(response: success(), index: 2)
        #expect(spy.isLoading == false, "The loading state should be false after a request success.")
        #expect(spy.requests.count == 3, "There should be no new requests after a request success.")
        #expect(spy.inputError == nil, "There should be no input error after a request success.")
        #expect(spy.generalError == nil, "There should be no general error after a request success.")
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
    
    private func success(nextAttemptAfter: Int = 60) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = """
        {
            "confirmationToken": "any token",
            "nextAttemptAfter": \(nextAttemptAfter),
            "otpLength": 4
        }
        """.data(using: .utf8)!
        return (data, response)
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
        let sut = LoginComposer.make(remote: spy.remote)
        spy.startSpying(sut: sut)
        return (sut, spy)
    }
}

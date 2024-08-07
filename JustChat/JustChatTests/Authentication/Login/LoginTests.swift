//
//  LoginTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Testing
import JustChat
import Foundation

struct LoginTests {
    @Test
    func sutPresentsLoading() {
        let (sut, spy) = makeSut()
        #expect(spy.isLoading == false, "Initially, it should not be loading")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "Should not be loading after submitting an empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.isLoading == false, "Should not be loading after changing the login input")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "Should be loading after submitting a non-empty login")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.isLoading == false, "Should not be loading after receiving a submit error")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "Should be loading after submitting a non-empty login again")
        
        spy.finishRemoteRequestWith(response: success(), index: 1)
        #expect(spy.isLoading == false, "Should not be loading after a successful submit")
    }
    
    @Test
    func sutPresentsInputError() {
        let (sut, spy) = makeSut()
        #expect(spy.inputError == nil, "Initially, there should not be an input error")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == LoginStrings.emptyInputError, "Should show empty input error after submitting an empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.inputError == nil, "Should not show an error after changing the login input")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Should not show an error after submitting a non-empty login")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.inputError == nil, "Should not show an error after request failure")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Should not show an error after another submit")
        
        spy.finishRemoteRequestWith(response: validation(error: "some error"), index: 1)
        #expect(spy.inputError == "some error", "Should show the validation error after receiving a validation error")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Should not show an error after another submit")
        
        spy.finishRemoteRequestWith(response: success(), index: 2)
        #expect(spy.inputError == nil, "Should not show an error after a successful submit")
    }
    
    @Test
    func sutPresentsGeneralError() {
        let (sut, spy) = makeSut()
        #expect(spy.generalError == nil, "Initially, there should not be a general error")
        
        sut.initiateLoginSubmit()
        #expect(spy.generalError == nil, "There should not be a general error after submitting an empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.generalError == nil, "There should not be a general error after changing the login input")
        
        sut.initiateLoginSubmit()
        #expect(spy.generalError == nil, "There should not be a general error after submitting a non-empty login")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.generalError == "Something went wrong...", "A general error should be shown after request failure")
        
        sut.tapToast()
        #expect(spy.generalError == nil, "There should not be a general error after dismissing the toast")
        
        sut.initiateLoginSubmit()
        #expect(spy.generalError == nil, "There should not be a general error after submitting again")
        
        spy.finishRemoteRequestWithError(index: 1)
        #expect(spy.generalError == "Something went wrong...", "A general error should be shown after another request failure")
        
        sut.initiateLoginSubmit()
        #expect(spy.generalError == nil, "There should not be a general error after submitting again")
        
        spy.finishRemoteRequestWith(response: validation(error: "any"), index: 2)
        #expect(spy.generalError == nil, "There should not be a general error after receiving a validation error")
        
        sut.initiateLoginSubmit()
        #expect(spy.generalError == nil, "There should not be a general error after submitting again")
        
        spy.finishRemoteRequestWith(response: success(), index: 3)
        #expect(spy.generalError == nil, "There should not be a general error after a successful submission")
    }
    
    @Test
    func sutSendsCorrectRequests() {
        let (sut, spy) = makeSut()
        #expect(spy.requests.isEmpty, "Initially, there shouldn't be any requests")
        
        sut.initiateLoginSubmit()
        #expect(spy.requests.isEmpty, "There shouldn't be any requests after submitting an empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.requests.isEmpty, "There shouldn't be any requests after changing login")
        
        sut.initiateLoginSubmit()
        expectRequestCorrect(spy.requests[0], for: "any login", "There should be request after submitting non-empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.requests.count == 1, "There shouldn't be new requests before previous request is completed after changing login")
        
        sut.initiateLoginSubmit()
        #expect(spy.requests.count == 1, "There shouldn't be new requests before previous request is completed after submit attempt")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.requests.count == 1, "There shouldn't be new requests after request completion")
        
        sut.changeLoginInput("another login")
        #expect(spy.requests.count == 1, "There shouldn't be new requests after changing login")
        
        sut.initiateLoginSubmit()
        expectRequestCorrect(spy.requests[1], for: "another login", "There should be new request after submitting non-empty login")
        
        spy.finishRemoteRequestWith(response: validation(error: "any"), index: 1)
        #expect(spy.requests.count == 2, "There shouldn't be new requests after receiving validation error")
        
        sut.initiateLoginSubmit()
        expectRequestCorrect(spy.requests[2], for: "another login", "There should be a new request after submitting non-empty login")

        spy.finishRemoteRequestWith(response: success(), index: 2)
        #expect(spy.requests.count == 3, "There shouldn't be new requests after success")
    }
    
    private func expectRequestCorrect(_ request: URLRequest, for login: String, _ comment: Comment?) {
        #expect(request.url?.path() == "/api/v1/login", comment)
        #expect(request.httpMethod == "POST", comment)
        #expect(request.httpBody == body(for: login), comment)
    }
    
    private func body(for login: String) -> Data {
        "{\"login\":\"\(login)\"}".data(using: .utf8)!
    }
    
    private func success() -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = "any".data(using: .utf8)!
        return (data, response)
    }
    
    private func validation(error: String) -> (Data, HTTPURLResponse) {
        let non2xx = 400
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: non2xx, httpVersion: nil, headerFields: nil)!
        let data = """
            {
                "errors": [
                    {
                        "field": "login"
                        "message": "\(error)"
                    }
                ]
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

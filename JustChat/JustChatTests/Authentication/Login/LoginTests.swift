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
        #expect(spy.isLoading == false, "Mustn't be loading initially")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == false, "Mustn't be loading after submitting empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.isLoading == false, "Mustn't be loading after changing login")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "Must be loading after submitting with not empty login")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.isLoading == false, "Mustn't be loading after receiving submit error")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoading == true, "Must be loading after submitting with not empty login again")
        
        spy.finishRemoteRequestWith(response: success(), index: 1)
        #expect(spy.isLoading == false, "Mustn't be loading after submit success")
    }
    
    @Test func sutPresentsInputError() {
        let (sut, spy) = makeSut()
        #expect(spy.inputError == nil, "Mustn't be an input error")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == LoginStrings.emptyInputError, "Must be an empty input error")
        
        sut.changeLoginInput("any login")
        #expect(spy.inputError == nil, "Mustn't be an error after login change")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Mustn't be an error after submit")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.inputError == nil, "Mustn't be an error after request failure")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Mustn't be an error after another submit")
        
        spy.finishRemoteRequestWith(response: validation(error: "some error"), index: 1)
        #expect(spy.inputError == "some error", "Must be an input error after receiving validation error")
        
        sut.initiateLoginSubmit()
        #expect(spy.inputError == nil, "Mustn't be an error after another submit")
        
        spy.finishRemoteRequestWith(response: success(), index: 2)
        #expect(spy.inputError == nil, "Mustn't be an error after success")
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

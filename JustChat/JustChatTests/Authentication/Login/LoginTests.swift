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
        #expect(spy.isLoadingUpdates == [false], "Must not be in a loading state initially")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoadingUpdates == [false], "Must not be in a loading state after submitting empty login")
        
        sut.changeLoginInput("any login")
        #expect(spy.isLoadingUpdates == [false], "Must not be in a loading state after changing login")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoadingUpdates == [false, true], "Must be in a loading state after submitting with not empty login")
        
        spy.finishRemoteRequestWithError(index: 0)
        #expect(spy.isLoadingUpdates == [false, true, false], "Must not be in a loading state after receiving submit error")
        
        sut.initiateLoginSubmit()
        #expect(spy.isLoadingUpdates == [false, true, false, true], "Must be in a loading state after submitting with not empty login again")
        
        spy.finishRemoteRequestWith(response: success(), index: 1)
        #expect(spy.isLoadingUpdates == [false, true, false, true, false], "Must not be in a loading state after submit success")
    }
    
    private func success() -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = "any".data(using: .utf8)!
        return (data, response)
    }
    
    typealias Sut = LoginViewModel
    
    private func makeSut() -> (Sut, LoginSpy) {
        let spy = LoginSpy()
        let sut = LoginComposer.make(remote: spy.remote)
        spy.startSpying(sut: sut)
        return (sut, spy)
    }
}

extension LoginTests.Sut {
    func initiateLoginSubmit() {
        self.submit()
    }
    
    func changeLoginInput(_ value: String) {
        self.login = value
    }
}

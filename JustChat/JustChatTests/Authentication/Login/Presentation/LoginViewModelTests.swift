//
//  LoginViewModelTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import JustChat

import Combine

@Suite
final class LoginViewModelTests {
    @Test
    func sutPresentsInitialState() {
        let (sut, spy) = makeSut()
        _ = sut
        
        #expect(spy.isLoading == false)
        #expect(spy.inputError == nil)
        #expect(spy.generalError == nil)
        #expect(spy.validatedCalls.isEmpty)
    }
    
    @Test
    func sutValidatesEmptyLogin() {
        let (sut, spy) = makeSut()
        sut.submit()
        
        #expect(spy.isLoading == false)
        #expect(spy.inputError == LoginStrings.emptyInputError)
        #expect(spy.generalError == nil)
        #expect(spy.validatedCalls.isEmpty)
    }
    
    typealias Sut = LoginViewModel
    
    private func makeSut() -> (Sut, Spy) {
        let sut = Sut()
        let spy = Spy()
        sut.onValidatedLoginSubmit = spy.appendValidated
        spy.startSpying(sut: sut)
        return (sut, spy)
    }
    
    final class Spy {
        var validatedCalls: [LoginRequest] = []
        
        var isLoading: Bool = false
        var inputError: String? = nil
        var generalError: String? = nil
        
        private var cancellables = Set<AnyCancellable>()
        
        func startSpying(sut: Sut) {
            sut.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
            sut.$inputError.bind(\.inputError, to: self, storeIn: &cancellables)
            sut.$generalError.bind(\.generalError, to: self, storeIn: &cancellables)
        }
        
        func appendValidated(_ request: LoginRequest) {
            validatedCalls.append(request)
        }
    }
}

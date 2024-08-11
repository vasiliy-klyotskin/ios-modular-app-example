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
    func sutHandlesSubmissionAndErrorsCorrectly() {
        let (sut, spy) = makeSut()
        
        // MARK: When sut is initiated
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "There should be no validated calls.")
        
        // MARK: When submit is called initially with empty input
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.inputError == LoginStrings.emptyInputError, "An empty input error should be present.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "No validation calls should be made.")
        
        // MARK: When login input is updated but not submitted
        sut.updateLogin("some login")
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.inputError == LoginStrings.emptyInputError, "The empty input error should persist.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "No validation calls should be made.")
        
        // MARK: When submit is called with valid input
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.inputError == nil, "The input error should be cleared.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls == ["some login"], "The login input should be validated and stored.")
        
        // MARK: When loading starts
        sut.startLoading()
        #expect(spy.isLoading == true, "The loading state should be true.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When loading finishes successfully
        sut.finishLoading()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When a general error occurs
        sut.handleError(.general("general error"))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == nil, "There should be no input error.")
        #expect(spy.generalError == "general error", "The general error should be set.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When an input error occurs
        sut.handleError(.input("input error"))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == "input error", "The input error should be set.")
        #expect(spy.generalError == "general error", "The general error should persist.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When another input error occurs
        sut.handleError(.input("another input error"))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.inputError == "another input error", "The input error should be updated.")
        #expect(spy.generalError == "general error", "The general error should persist.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When login input is updated again and submitted
        sut.updateLogin("another login")
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.inputError == nil, "The input error should be cleared.")
        #expect(spy.generalError == nil, "The general error should be cleared.")
        #expect(spy.validatedCalls == ["some login", "another login"], "The new login input should be validated and added.")
    }
    
    typealias Sut = LoginViewModel
    
    private var leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, Spy) {
        let sut = Sut()
        let spy = Spy()
        sut.onValidatedLoginSubmit = spy.appendValidated
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
    
    deinit {
        leakChecker.check()
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

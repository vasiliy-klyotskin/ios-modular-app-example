//
//  RegisterViewModelTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/20/24.
//

import Testing
@testable import JustChat

@Suite
final class RegisterViewModelTests {
    @Test
    func sutHandlesSubmissionCorrectly() {
        let (sut, spy) = makeSut()
        
        // MARK: When sut is initiated
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == nil, "There should be no email error.")
        #expect(spy.usernameError == nil, "There should be no username error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "There should be no validated calls.")
        
        // MARK: When submit is called initially with empty inputs
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.emailError == RegisterStrings.emptyEmailError, "An empty email error should be present.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "An empty username error should be present.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "No validation calls should be made.")

        // MARK: When inputs are updated but not submitted
        sut.updateEmail("some email")
        sut.updateUsername("John")
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.emailError == RegisterStrings.emptyEmailError, "An empty email error should persist.")
        #expect(spy.usernameError == RegisterStrings.emptyUsernameError, "An empty username error should persist.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.isEmpty, "No validation calls should be made.")
        
        // MARK: When submit is called with valid input
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.emailError == nil, "The email error should be cleared.")
        #expect(spy.usernameError == nil, "The username error should be cleared.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls == [.init(email: "some email", username: "John")], "The request should be validated.")

        // MARK: When loading starts
        sut.startLoading()
        #expect(spy.isLoading == true, "The loading state should be true.")
        #expect(spy.emailError == nil, "There should be no email error.")
        #expect(spy.usernameError == nil, "There should be no useranme error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When loading finishes
        sut.finishLoading()
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == nil, "There should be no email error.")
        #expect(spy.usernameError == nil, "There should be no username error.")
        #expect(spy.generalError == nil, "There should be no general error.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When a general error occurs
        sut.handleError(.general("general error"))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == nil, "There should be no email error.")
        #expect(spy.usernameError == nil, "There should be no username error.")
        #expect(spy.generalError == "general error", "The general error should be set.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When an email error occurs
        sut.handleError(.validation([.email("email error")]))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == "email error", "The email error should be set.")
        #expect(spy.usernameError == nil, "There should be no username error.")
        #expect(spy.generalError == "general error", "The general error should persist.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When an username error occurs
        sut.handleError(.validation([.username("username error")]))
        #expect(spy.isLoading == false, "The loading state should be false.")
        #expect(spy.emailError == "email error", "The email error should persist.")
        #expect(spy.usernameError == "username error", "The username error should be set.")
        #expect(spy.generalError == "general error", "The general error should persist.")
        #expect(spy.validatedCalls.count == 1, "The validated calls count should remain the same.")
        
        // MARK: When inputs are updated again and submitted
        sut.updateEmail("new email")
        sut.updateUsername("new username")
        sut.submit()
        #expect(spy.isLoading == false, "The loading state should remain false.")
        #expect(spy.emailError == nil, "The email error should be cleared.")
        #expect(spy.usernameError == nil, "The username error should be cleared.")
        #expect(spy.generalError == nil, "The general error should be cleared.")
        #expect(spy.validatedCalls == [
            .init(email: "some email", username: "John"), .init(email: "new email", username: "new username")
        ], "The new request should be validated.")
    }
    
    typealias Sut = RegisterViewModel
    
    private var leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, RegisterViewModelSpy) {
        let sut = Sut()
        let spy = RegisterViewModelSpy()
        sut.onValidatedRegisterSubmit = spy.appendValidated
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
}

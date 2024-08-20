//
//  RegisterViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Combine

final class RegisterViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var emailError: String? = nil
    @Published var usernameError: String? = nil
    @Published var generalError: String? = nil
    
    private var emailInput: String = ""
    private var usernameInput: String = ""
    
    var onValidatedRegisterSubmit: (RegisterRequest) -> Void = { _ in }
    
    func submit() {
        emailError = nil
        usernameError = nil
        generalError = nil
        if emailInput.isEmpty {
            emailError = RegisterStrings.emptyEmailError
        }
        if usernameInput.isEmpty {
            usernameError = RegisterStrings.emptyUsernameError
        }
        if !emailInput.isEmpty && !usernameInput.isEmpty {
            onValidatedRegisterSubmit(.init(email: emailInput, username: usernameInput))
        }
    }
    
    func updateEmail(_ value: String) {
        emailInput = value
    }
    
    func updateUsername(_ value: String) {
        usernameInput = value
    }
    
    func startLoading() {
        isLoading = true
    }
    
    func finishLoading() {
        isLoading = false
    }
    
    func handleError(_ error: RegisterError) {
        switch error {
        case .validation(let validationErrors):
            validationErrors.forEach(handleValidationError)
        case .general(let error):
            generalError = error
        }
    }
    
    private func handleValidationError(_ error: RegisterError.Validation) {
        switch error {
        case .email(let error):
            emailError = error
        case .username(let error):
            usernameError = error
        }
    }
}

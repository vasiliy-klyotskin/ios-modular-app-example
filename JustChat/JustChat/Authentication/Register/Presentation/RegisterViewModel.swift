//
//  RegisterViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Combine

final class RegisterViewModel: ObservableObject {
    @Published var isLoading = false
    
    var onValidatedRegisterSubmit: (RegisterRequest) -> Void = { _ in }
    var onLoginTapped: () -> Void = {}
    
    let email: TextFieldViewModel
    let username: TextFieldViewModel
    let toast: ToastViewModel
    
    init(username: TextFieldViewModel, email: TextFieldViewModel, toast: ToastViewModel) {
        self.toast = toast
        self.email = email
        self.username = username
    }
    
    func submit() {
        email.updateError(nil)
        username.updateError(nil)
        toast.updateMessage(nil)
        if email.input.isEmpty {
            email.updateError(RegisterStrings.emptyEmailError)
        }
        if username.input.isEmpty {
            username.updateError(RegisterStrings.emptyUsernameError)
        }
        if !email.input.isEmpty && !username.input.isEmpty {
            onValidatedRegisterSubmit(.init(email: email.input, username: username.input))
        }
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
            toast.updateMessage(error)
        }
    }
    
    private func handleValidationError(_ error: RegisterError.Validation) {
        switch error {
        case .email(let error):
            email.updateError(error)
        case .username(let error):
            username.updateError(error)
        }
    }
    
    func loginTapped() {
        onLoginTapped()
    }
}

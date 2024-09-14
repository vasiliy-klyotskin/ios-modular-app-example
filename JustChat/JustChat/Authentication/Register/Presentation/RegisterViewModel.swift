//
//  RegisterViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Combine

final class RegisterViewModel: ObservableObject {
    @Published private(set) var submitButtonConfig: ButtonConfig = .standard(title: RegisterStrings.submitButtonTitle)
    @Published private(set) var isContentDisabled: Bool = false
    
    let email: TextFieldViewModel
    let username: TextFieldViewModel
    let toast: ToastViewModel
    
    var onValidatedRegisterSubmit: (RegisterRequest) -> Void = { _ in }
    var onLoginTapped: () -> Void = {}
    
    init(toast: ToastViewModel) {
        self.toast = toast
        self.email = .init()
        self.username = .init()
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
        submitButtonConfig = .loading()
        isContentDisabled = true
    }
    
    func finishLoading() {
        submitButtonConfig = .standard(title: RegisterStrings.submitButtonTitle)
        isContentDisabled = false
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

//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

final class LoginViewModel: ObservableObject {
    var onValidatedLoginSubmit: (LoginRequest) -> Void = { _ in }
    var onGoogleAuthTap: () -> Void = {}
    var onRegisterTap: () -> Void = {}
    
    @Published private(set) var submitButtonConfig: ButtonConfig = .standard(title: LoginStrings.continueButton)
    @Published private(set) var isContentDisabled = false
    
    let input: TextFieldViewModel
    let toast: ToastViewModel
        
    init(input: TextFieldViewModel, toast: ToastViewModel) {
        self.input = input
        self.toast = toast
    }
    
    func submit() {
        input.updateError(nil)
        toast.updateMessage(nil)
        if input.input.isEmpty {
            input.updateError(LoginStrings.emptyInputError)
        } else {
            onValidatedLoginSubmit(input.input)
        }
    }
    
    func startLoading() {
        submitButtonConfig = .loading()
        isContentDisabled = true
    }
    
    func finishLoading() {
        submitButtonConfig = .standard(title: LoginStrings.continueButton)
        isContentDisabled = false
    }
    
    func handleError(_ error: LoginError) {
        switch error {
        case .input(let inputError):
            input.updateError(inputError)
        case .general(let generalError):
            toast.updateMessage(generalError)
        }
    }
    
    func registerTapped() {
        onRegisterTap()
    }
    
    func googleAuthTapped() {
        onGoogleAuthTap()
    }
}

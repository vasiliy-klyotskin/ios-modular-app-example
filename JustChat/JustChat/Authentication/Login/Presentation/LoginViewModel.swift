//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var inputError: String? = nil
    @Published var generalError: String? = nil
    
    var onValidatedLoginSubmit: (LoginRequest) -> Void = { _ in }
    var onGoogleAuthTap: () -> Void = {}
    var onRegisterTap: () -> Void = {}
    
    private var login: String = ""
    
    func submit() {
        inputError = nil
        generalError = nil
        if login.isEmpty {
            inputError = LoginStrings.emptyInputError
        } else {
            onValidatedLoginSubmit(login)
        }
    }
    
    func updateLogin(_ login: String) {
        self.login = login
    }
    
    func startLoading() {
        self.isLoading = true
    }
    
    func finishLoading() {
        self.isLoading = false
    }
    
    func handleError(_ error: LoginError) {
        switch error {
        case .input(let inputError):
            self.inputError = inputError
        case .general(let generalError):
            self.generalError = generalError
        }
    }
    
    func registerTapped() {
        onRegisterTap()
    }
    
    func googleAuthTapped() {
        onGoogleAuthTap()
    }
}

//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

public final class LoginViewModel {
    @Published public var isLoading: Bool = false
    @Published public var inputError: String? = nil
    @Published public var generalError: String? = nil
    
    private let onValidatedLoginSubmit: (LoginRequest) -> Void
    private var login: String = ""
    
    init(onValidatedLoginSubmit: @escaping (LoginRequest) -> Void) {
        self.onValidatedLoginSubmit = onValidatedLoginSubmit
    }
    
    public func submit() {
        if isLoading { return }
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
}

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
    
    public var onValidatedLoginSubmit: (LoginRequest) -> Void = { _ in }
    
    private var login: String = ""
    
    public init() {}
    
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
    
    public func updateLogin(_ login: String) {
        self.login = login
    }
    
    public func startLoading() {
        self.isLoading = true
    }
    
    public func finishLoading() {
        self.isLoading = false
    }
    
    public func handleError(_ error: LoginError) {
        switch error {
        case .input(let inputError):
            self.inputError = inputError
        case .general(let generalError):
            self.generalError = generalError
        }
    }
}

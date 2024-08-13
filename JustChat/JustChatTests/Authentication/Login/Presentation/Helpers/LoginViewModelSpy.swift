//
//  LoginViewModel+Spy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
@testable import JustChat

final class LoginViewModelSpy {
    var validatedCalls: [LoginRequest] = []
    
    var isLoading: Bool = false
    var inputError: String? = nil
    var generalError: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: LoginViewModelTests.Sut) {
        sut.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
        sut.$inputError.bind(\.inputError, to: self, storeIn: &cancellables)
        sut.$generalError.bind(\.generalError, to: self, storeIn: &cancellables)
    }
    
    func appendValidated(_ request: LoginRequest) {
        validatedCalls.append(request)
    }
}

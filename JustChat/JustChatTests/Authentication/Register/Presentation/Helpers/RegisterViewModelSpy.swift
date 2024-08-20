//
//  RegisterViewModelSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/20/24.
//

import Combine
@testable import JustChat

final class RegisterViewModelSpy {
    var validatedCalls: [RegisterRequest] = []
    
    var isLoading: Bool = false
    var emailError: String? = nil
    var usernameError: String? = nil
    var generalError: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: RegisterViewModelTests.Sut) {
        sut.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
        sut.$emailError.bind(\.emailError, to: self, storeIn: &cancellables)
        sut.$usernameError.bind(\.usernameError, to: self, storeIn: &cancellables)
        sut.$generalError.bind(\.generalError, to: self, storeIn: &cancellables)
    }
    
    func appendValidated(_ request: RegisterRequest) {
        validatedCalls.append(request)
    }
}

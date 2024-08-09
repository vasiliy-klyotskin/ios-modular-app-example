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
    
    private let submitter: (LoginRequest) -> AnyPublisher<LoginModel, LoginError>
    private let onSuccess: (LoginModel) -> Void
    
    private var login: String = ""
    private var cancellables: [AnyCancellable] = []
    
    init(
        submitter: @escaping (LoginRequest) -> AnyPublisher<LoginModel, LoginError>,
        onSuccess: @escaping (LoginModel) -> Void
    ) {
        self.submitter = submitter
        self.onSuccess = onSuccess
    }
    
    public func submit() {
        if isLoading { return }
        inputError = nil
        generalError = nil
        if login.isEmpty {
            inputError = LoginStrings.emptyInputError
        } else {
            isLoading = true
            startSubmitting()
        }
    }
    
    func updateLogin(_ login: String) {
        self.login = login
    }
    
    private func startSubmitting() {
        submitter(login).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error):
                self?.handle(error: error)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] model in
            self?.onSuccess(model)
        }).store(in: &cancellables)
    }
    
    private func handle(error: LoginError) {
        switch error {
        case .input(let inputError):
            self.inputError = inputError
        case .general(let generalError):
            self.generalError = generalError
        }
    }
}

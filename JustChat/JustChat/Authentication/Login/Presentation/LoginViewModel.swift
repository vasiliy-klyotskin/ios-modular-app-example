//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

public final class LoginViewModel {
    @Published public var inputError: String? = nil
    @Published public var isLoading: Bool = false
    
    private let submitter: LoginSubmitter
    private var login: String = ""
    private var cancellables: [AnyCancellable] = []
    
    init(submitter: @escaping LoginSubmitter) {
        self.submitter = submitter
    }
    
    public func submit() {
        inputError = nil
        if login.isEmpty {
            inputError = LoginStrings.emptyInputError
        } else {
            startSubmitting()
        }
    }
    
    func update(login: String) {
        self.login = login
    }
    
    private func startSubmitting() {
        isLoading = true
        submitter(login).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error):
                self?.handle(error: error)
            case .finished:
                break
            }
        }, receiveValue: { _ in
            
        }).store(in: &cancellables)
    }
    
    private func handle(error: LoginError) {
        switch error {
        case .input(let inputError):
            self.inputError = inputError
        default: break
        }
    }
}

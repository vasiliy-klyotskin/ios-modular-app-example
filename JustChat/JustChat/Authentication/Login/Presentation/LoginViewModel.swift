//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

public final class LoginViewModel {
    @Published public var isLoading: Bool = false
    @Published public var login: String = ""
    
    private let submitter: LoginSubmitter
    private var cancellables: [AnyCancellable] = []
    
    init(submitter: @escaping LoginSubmitter) {
        self.submitter = submitter
    }
    
    public func submit() {
        if login.isEmpty { return }
        
        
        isLoading = true
        submitter(login).sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let failure):
                break
            case .finished:
                break
            }
        }, receiveValue: { _ in
            
        }).store(in: &cancellables)
    }
}

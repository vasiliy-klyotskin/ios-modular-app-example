//
//  LoginSubmitStarter.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

import Combine
import Foundation

final class LoginSubmitStarter {
    private var cancellables: Set<AnyCancellable> = []
    private let onSuccess: (LoginModel) -> Void
    var submitter: ((LoginRequest) -> AnyPublisher<LoginModel, LoginError>)?
    
    init(onSuccess: @escaping (LoginModel) -> Void) {
        self.onSuccess = onSuccess
    }
    
    func start(request: LoginRequest) {
        submitter?(request)
            .sink(receiveCompletion: { _ in }, receiveValue: onSuccess)
            .store(in: &cancellables)
    }
}

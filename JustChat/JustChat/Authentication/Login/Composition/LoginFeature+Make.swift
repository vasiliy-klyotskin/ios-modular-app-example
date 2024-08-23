//
//  LoginFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Combine

extension LoginFeature {
    func view() -> LoginView { .init(vm: self) }
    
    static func make(env: LoginEnvironment, events: LoginEvents) -> LoginFeature {
        let vm = LoginViewModel(inputVm: .init(), toastVm: .make(scheduler: env.scheduler))
        vm.onValidatedLoginSubmit = start(submission <~ env <~ events <~ vm)
        vm.onRegisterTap = events.onRegisterButtonTapped
        vm.onGoogleAuthTap = events.onGoogleOAuthButtonTapped
        return vm
    }
    
    private static func submission(
        env: LoginEnvironment,
        events: LoginEvents,
        vm: Weak<LoginViewModel>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        env.httpClient(login.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(LoginError.fromRemoteError)
            .map(LoginModel.fromLoginAndDto <~ login)
            .onSubscription(vm.do { $0.startLoading })
            .onCompletion(vm.do { $0.finishLoading })
            .onFailure(vm.do { $0.handleError })
            .onOutput(events.onSuccessfulSubmitLogin)
            .eraseToAnyPublisher()
    }
}

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
            .map(LoginModel.fromDto)
            .receive(on: env.scheduler)
            .onLoadingStart(vm.do { $0.startLoading })
            .onLoadingFinish(vm.do { $0.finishLoading })
            .onLoadingFailure(vm.do { $0.handleError })
            .onLoadingSuccess(events.onSuccessfulSubmitLogin)
            .eraseToAnyPublisher()
    }
}

//
//  LoginFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Combine
import CompositionSupport

extension LoginFeature {
    static func make(env: LoginEnvironment, events: LoginEvents) -> LoginFeature {
        let vm = LoginViewModel(input: .init(), toast: env.toast)
        vm.onValidatedLoginSubmit = start(submission <~ env <~ events <~ vm)
        vm.onRegisterTap = events.onRegisterButtonTapped
        vm.onGoogleAuthTap = events.onGoogleSignInButtonTapped
        return vm
    }
    
    func view() -> LoginView {
        .init(vm: self)
    }
    
    private static func submission(
        env: LoginEnvironment,
        events: LoginEvents,
        vm: Weak<LoginViewModel>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        env.remoteClient(login.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(LoginError.fromRemoteError)
            .map(LoginModel.fromDto)
            .receive(on: env.uiScheduler)
            .onLoadingStart { vm.obj?.startLoading() }
            .onLoadingFinish { vm.obj?.finishLoading() }
            .onLoadingFailure { vm.obj?.handleError($0) }
            .onLoadingSuccess(events.onSuccessfulSubmitLogin)
            .eraseToAnyPublisher()
    }
}

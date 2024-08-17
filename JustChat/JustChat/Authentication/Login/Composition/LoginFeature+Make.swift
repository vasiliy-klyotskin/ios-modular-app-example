//
//  LoginFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Combine

extension LoginFeature {
    func view() -> LoginView {
        LoginView(vm: submitVm, subviews: LoginSubviews(
            submitButton: Button.make <~ submitVm.submit,
            googleOAuthButton: GoogleAuthButton.init <~ events.onGoogleOAuthButtonTapped,
            loginInput: TextField.make <~ inputVm,
            registerButton: LinkButton.make <~ events.onRegisterButtonTapped,
            errorToast: Toast.make <~ toastVm
        ))
    }
    
    static func make(env: LoginEnvironment, events: LoginEvents) -> LoginFeature {
        let submitVm = LoginViewModel()
        let toastVm = ToastViewModel.make(message: submitVm.$generalError, scheduler: env.scheduler)
        let inputVm = TextFieldViewModel.make(error: submitVm.$inputError, onInput: submitVm.updateLogin)
        let cache = LoginCache(currentTime: env.currentTime)
        let submission = submission <~ env <~ events <~ cache <~ submitVm
        submitVm.onValidatedLoginSubmit = start(submission)
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm, events: events)
    }
    
    private static func submission(
        env: LoginEnvironment,
        events: LoginEvents,
        cache: LoginCache,
        vm: Weak<LoginViewModel>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        lift(cache.load <~ login)
            .fallback(to: env.httpClient(login.urlRequest)
                .mapError(RemoteMapper.mapError <~ RemoteStrings.values)
                .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
                .mapError(LoginError.fromRemoteError)
                .map(LoginModel.fromLoginAndDto <~ login)
                .onOutput(cache.save)
                .onSubscription(vm.do { $0.startLoading })
                .onCompletion(vm.do { $0.finishLoading })
                .onFailure(vm.do { $0.handleError })
                .eraseToAnyPublisher())
            .onOutput(events.onSuccessfulSubmitLogin)
            .eraseToAnyPublisher()
    }
}

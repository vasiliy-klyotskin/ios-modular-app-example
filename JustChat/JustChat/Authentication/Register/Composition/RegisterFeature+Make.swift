//
//  RegisterFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation
import Combine

extension RegisterFeature {
    func view() -> RegisterView {
        .init(vm: registerVm, emailInput: emailInputVm.view, usernameInput: usernameInputVm.view, toast: toastVm.view)
    }
    
    static func make(env: RegisterEnvironment, events: RegisterEvents) -> RegisterFeature {
        let registerVm = RegisterViewModel()
        let emailInputVm = TextFieldViewModel.make(error: registerVm.$emailError, onInput: registerVm.updateEmail)
        let usernameInputVm = TextFieldViewModel.make(error: registerVm.$usernameError, onInput: registerVm.updateUsername)
        let toastVm = ToastViewModel.make(message: registerVm.$generalError, scheduler: env.scheduler)
        let submission = submission <~ env <~ events <~ registerVm
        registerVm.onValidatedRegisterSubmit = start(submission)
        registerVm.onLoginTapped = events.onLoginButtonTapped
        return .init(emailInputVm: emailInputVm, usernameInputVm: usernameInputVm, toastVm: toastVm, registerVm: registerVm)
    }
    
    private static func submission(
        env: RegisterEnvironment,
        events: RegisterEvents,
        vm: Weak<RegisterViewModel>,
        request: RegisterRequest
    ) -> AnyPublisher<RegisterModel, RegisterError> {
        env.httpClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(RegisterError.fromRemoteError)
            .map(RegisterModel.fromRequestAndDto <~ request)
            .onSubscription(vm.do { $0.startLoading })
            .onCompletion(vm.do { $0.finishLoading })
            .onFailure(vm.do { $0.handleError })
            .onOutput(events.onSuccessfulSubmitRegister)
            .eraseToAnyPublisher()
    }
}

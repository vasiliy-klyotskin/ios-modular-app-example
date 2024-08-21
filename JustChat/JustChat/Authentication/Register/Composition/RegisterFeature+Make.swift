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
        RegisterView(vm: registerVm, subviews: .init(
            usernameInput: TextField.make <~ usernameInputVm,
            emailInput: TextField.make <~ emailInputVm,
            submitButton: Button.make <~ registerVm.submit,
            loginButton: LinkButton.make <~ events.onLoginButtonTapped,
            toast: Toast.make <~ toastVm
        ))
    }
    
    static func make(env: RegisterEnvironment, events: RegisterEvents) -> RegisterFeature {
        let registerVm = RegisterViewModel()
        let emailInputVm = TextFieldViewModel.make(error: registerVm.$emailError, onInput: registerVm.updateEmail)
        let usernameInputVm = TextFieldViewModel.make(error: registerVm.$usernameError, onInput: registerVm.updateUsername)
        let toastVm = ToastViewModel.make(message: registerVm.$generalError, scheduler: env.scheduler)
        let submission = submission <~ env <~ events <~ registerVm
        registerVm.onValidatedRegisterSubmit = start(submission)
        return .init(emailInputVm: emailInputVm, usernameInputVm: usernameInputVm, toastVm: toastVm, registerVm: registerVm, events: events)
    }
    
    private static func submission(
        env: RegisterEnvironment,
        events: RegisterEvents,
        vm: Weak<RegisterViewModel>,
        request: RegisterRequest
    ) -> AnyPublisher<RegisterModel, RegisterError> {
        env.httpClient(request.remote)
            .mapError(RemoteMapper.mapError <~ RemoteStrings.values)
            .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
            .mapError(RegisterError.fromRemoteError)
            .map(RegisterModel.fromRequestAndDto <~ request)
            .onSubscription(vm.do { $0.startLoading })
            .onCompletion(vm.do { $0.finishLoading })
            .onFailure(vm.do { $0.handleError })
            .onOutput(events.onSuccessfulSubmitRegister)
            .eraseToAnyPublisher()
    }
}

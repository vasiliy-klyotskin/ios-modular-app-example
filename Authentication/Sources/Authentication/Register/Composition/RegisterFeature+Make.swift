//
//  RegisterFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation
import Combine
import CompositionSupport

extension RegisterFeature {
    static func make(env: RegisterEnvironment, events: RegisterEvents) -> RegisterFeature {
        let vm = RegisterViewModel(toast: env.toast)
        vm.onValidatedRegisterSubmit = start(submission <~ env <~ events <~ vm)
        vm.onLoginTapped = events.onLoginButtonTapped
        return vm
    }
    
    func view() -> RegisterView {
        .init(vm: self)
    }
    
    private static func submission(
        env: RegisterEnvironment,
        events: RegisterEvents,
        vm: Weak<RegisterViewModel>,
        request: RegisterRequest
    ) -> AnyPublisher<RegisterModel, RegisterError> {
        env.remoteClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(RegisterError.fromRemoteError)
            .map(RegisterModel.fromDto)
            .receive(on: env.uiScheduler)
            .onLoadingStart { vm.obj?.startLoading() }
            .onLoadingFinish { vm.obj?.finishLoading() }
            .onLoadingFailure { vm.obj?.handleError($0) }
            .onLoadingSuccess(events.onSuccessfulSubmitRegister)
            .eraseToAnyPublisher()
    }
}

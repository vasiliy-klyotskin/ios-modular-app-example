//
//  LoginFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Combine

public extension LoginFeature {
    static func make(
        remote: @escaping RemoteClient,
        onReadyForOtpStep: @escaping (LoginModel) -> Void,
        currentTime: @escaping () -> Date = Date.init
    ) -> LoginFeature {
        let submitVm = LoginViewModel()
        let toastVm = ToastViewModel.make(error: submitVm.$generalError)
        let inputVm = TextFieldViewModel.make(error: submitVm.$inputError, onInput: submitVm.updateLogin)
        let cache = LoginCache(currentTime: currentTime)
        submitVm.onValidatedLoginSubmit = start(submitter <~ remote <~ cache <? submitVm <~ onReadyForOtpStep)
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func submitter(
        remote: @escaping RemoteClient,
        cache: LoginCache,
        vm: LoginViewModel?,
        onSuccess: @escaping (LoginModel) -> Void,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        liftToPublisher(cache.load <~ login)
            .fallback(to: remote(login.urlRequest)
                .mapError(RemoteMapper.mapError <~ RemoteStrings.values)
                .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
                .mapError(LoginError.fromRemoteError)
                .map(LoginModel.fromLoginAndDto <~ login)
                .onSubscription(vm?.startLoading)
                .onCompletion(vm?.finishLoading)
                .onFailure(vm?.handleError)
                .onOutput(cache.save)
                .eraseToAnyPublisher()
            )
            .onOutput(onSuccess)
            .eraseToAnyPublisher()
    }
}

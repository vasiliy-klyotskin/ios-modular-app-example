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
        client: @escaping RemoteClient,
        onReadyForOtpStep: @escaping (LoginModel) -> Void,
        currentTime: @escaping () -> Date = Date.init,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) -> LoginFeature {
        let submitVm = LoginViewModel()
        let toastVm = ToastViewModel.make(error: submitVm.$generalError, scheduler: scheduler)
        let inputVm = TextFieldViewModel.make(error: submitVm.$inputError, onInput: submitVm.updateLogin)
        let cache = LoginCache(currentTime: currentTime)
        let remote = remoteSubmit <~ client <~ cache <? submitVm <~ scheduler
        let submission = cachedSubmit <~ cache <~ onReadyForOtpStep <~ remote
        submitVm.onValidatedLoginSubmit = start(submission)
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func cachedSubmit(
        cache: LoginCache,
        onSuccess: @escaping (LoginModel) -> Void,
        remote: @escaping (LoginRequest) -> AnyPublisher<LoginModel, LoginError>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        lift(cache.load <~ login)
            .fallback(to: remote <~ login)
            .onOutput(onSuccess)
            .eraseToAnyPublisher()
    }
    
    private static func remoteSubmit(
        client: @escaping RemoteClient,
        cache: LoginCache,
        vm: LoginViewModel?,
        scheduler: AnySchedulerOf<DispatchQueue>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        client(login.urlRequest)
            .mapError(RemoteMapper.mapError <~ RemoteStrings.values)
            .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
            .mapError(LoginError.fromRemoteError)
            .map(LoginModel.fromLoginAndDto <~ login)
            .onOutput(cache.save)
            .receive(on: scheduler)
            .onSubscription(weakify(vm, { $0.startLoading }))
            .onCompletion(weakify(vm, { $0.finishLoading }))
            .onFailure(weakify(vm, { $0.handleError }))
            .eraseToAnyPublisher()
    }
}

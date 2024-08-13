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
        let submission = submission <~ client <~ cache <~ submitVm <~ onReadyForOtpStep <~ scheduler
        submitVm.onValidatedLoginSubmit = start(submission)
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func submission(
        client: @escaping RemoteClient,
        cache: LoginCache,
        vm: Weak<LoginViewModel>,
        onSuccess: @escaping (LoginModel) -> Void,
        scheduler: AnySchedulerOf<DispatchQueue>,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        lift(cache.load <~ login)
            .fallback(to: client(login.urlRequest)
                .mapError(RemoteMapper.mapError <~ RemoteStrings.values)
                .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
                .mapError(LoginError.fromRemoteError)
                .map(LoginModel.fromLoginAndDto <~ login)
                .onOutput(cache.save)
                .onSubscription(vm.do { $0.startLoading })
                .onCompletion(vm.do { $0.finishLoading })
                .onFailure(vm.do { $0.handleError })
                .eraseToAnyPublisher())
            .onOutput(onSuccess)
            .eraseToAnyPublisher()
    }
}

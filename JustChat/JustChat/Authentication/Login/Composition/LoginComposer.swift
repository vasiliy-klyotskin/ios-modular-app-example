//
//  LoginComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Foundation
import Combine

public typealias Remote = (URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>

public enum LoginComposer {
    public static func make(
        remote: @escaping Remote,
        onReadyForOtpStep: @escaping (LoginModel) -> Void,
        currentTime: @escaping () -> Date = Date.init
    ) -> LoginFeature {
        let submitVm = LoginViewModel()
        let toastVm = ToastComposer.compose(error: submitVm.$generalError)
        let inputVm = TextFieldComposer.compose(error: submitVm.$inputError, onInput: submitVm.updateLogin)
        let cache = LoginCache(currentTime: currentTime)
        submitVm.onValidatedLoginSubmit = start(submitter <~ remote <~ cache <~ submitVm <~ onReadyForOtpStep)
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func submitter(
        remote: @escaping Remote,
        cache: LoginCache,
        vm: LoginViewModel,
        onSuccess: @escaping (LoginModel) -> Void,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        liftToPublisher(cache.load <~ login)
            .fallback(to: remote(login.urlRequest)
                .mapError(RemoteMapper.mapError <~ remoteStrings)
                .flatMapResult(RemoteMapper.mapSuccess <~ remoteStrings)
                .mapError(LoginError.fromRemoteError)
                .map(LoginModel.fromLoginAndDto <~ login)
                .onSubscription(weakify(vm, { $0.startLoading }))
                .onCompletion(weakify(vm, { $0.finishLoading }))
                .onFailure(weakify(vm, { $0.handleError }))
                .onOutput(cache.save)
                .eraseToAnyPublisher()
            )
            .onOutput(onSuccess)
            .eraseToAnyPublisher()
    }
    
    private static var remoteStrings: RemoteStrings {
        .init(system: "Something went wrong...")
    }
}

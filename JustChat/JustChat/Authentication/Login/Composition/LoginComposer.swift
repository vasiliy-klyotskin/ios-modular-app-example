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
        let starter = LoginSubmitStarter(onSuccess: onReadyForOtpStep)
        let submitVm = LoginViewModel(onValidatedLoginSubmit: starter.start)
        let toastVm = ToastViewModel(submitVm.$generalError)
        let inputVm = TextFieldViewModel(errorPublisher: submitVm.$inputError, onInput: submitVm.updateLogin)
        let cache = LoginCache(currentTime: currentTime)
        starter.submitter = makeSubmitter <~ remote <~ cache <~ submitVm
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func makeSubmitter(
        remote: @escaping Remote,
        cache: LoginCache,
        vm: LoginViewModel,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        liftToPublisher(cache.load <~ login).fallback(to: remote(login.urlRequest)
            .mapError(RemoteMapper.mapError <~ remoteStrings)
            .flatMapResult(RemoteMapper.mapSuccess <~ remoteStrings)
            .mapError(LoginError.fromRemoteError)
            .map(LoginModel.fromLoginAndDto <~ login)
            .onStart(weakify(vm, { $0.startLoading }))
            .onFinish(weakify(vm, { $0.finishLoading }))
            .onError(weakify(vm, { $0.handleError }))
            .onSuccess(cache.save)
            .eraseToAnyPublisher()
        )
    }
    
    private static var remoteStrings: RemoteStrings {
        .init(system: "Something went wrong...")
    }
}

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
        onReadyForOtpStep: @escaping (LoginModel) -> Void
    ) -> LoginFeature {
        let submitter = makeSubmitter <~ remote
        let submitVm = LoginViewModel(submitter: submitter, onSuccess: onReadyForOtpStep)
        let toastVm = ToastViewModel(submitVm.$generalError)
        let inputVm = TextFieldViewModel(
            errorPublisher: submitVm.$inputError,
            onInput: submitVm.updateLogin
        )
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func makeSubmitter(
        remote: @escaping Remote,
        login: LoginRequest
    ) -> AnyPublisher<LoginModel, LoginError> {
        let remoteStrings = RemoteStrings(system: "Something went wrong...")
        return remote(login.loginRequest())
            .mapError(RemoteMapper.mapError <~ remoteStrings)
            .flatMapResult(RemoteMapper.mapSuccess <~ remoteStrings)
            .mapError(LoginError.fromRemoteError)
            .map(LoginModel.fromLoginAndDto <~ login)
            .eraseToAnyPublisher()
    }
}

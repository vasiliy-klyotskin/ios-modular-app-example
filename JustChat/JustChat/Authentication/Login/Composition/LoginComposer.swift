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
        let submitter = makeSubmitter(remote: remote)
        let submitVm = LoginViewModel(submitter: submitter, onSuccess: onReadyForOtpStep)
        let toastVm = ToastViewModel(submitVm.$generalError)
        let inputVm = TextFieldViewModel(
            errorPublisher: submitVm.$inputError,
            onInput: submitVm.updateLogin
        )
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func makeSubmitter(remote: @escaping Remote) -> LoginSubmitter {{ login in
        let remoteStrings = RemoteStrings(system: "Something went wrong...")
        return remote(login.loginRequest())
            .mapError(RemoteMapper.map(strings: remoteStrings))
            .flatMapResult(RemoteMapper.map(strings: remoteStrings))
            .mapError(LoginError.from(remoteError:))
            .map(curry(LoginModel.from)(login))
            .eraseToAnyPublisher()
    }}
}

public func curry<A, B, C>(_ fun: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in fun(a, b) }}
}

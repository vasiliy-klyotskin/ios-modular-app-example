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
    public static func make(remote: @escaping Remote) -> LoginFeature {
        let submitter = makeSubmitter(remote: remote)
        let submitVm = LoginViewModel(submitter: submitter)
        let toastVm = ToastViewModel(submitVm.$generalError)
        let inputVm = TextFieldViewModel(
            errorPublisher: submitVm.$inputError,
            onInput: submitVm.updateLogin
        )
        return .init(submitVm: submitVm, inputVm: inputVm, toastVm: toastVm)
    }
    
    private static func makeSubmitter(remote: @escaping Remote) -> LoginSubmitter {{ _ in
        remote(URLRequest(url: URL(string: "https://any.com")!))
            .mapError { _ in LoginError.general("Something went wrong...") }
            .flatMap { (data, status) in
                if status.statusCode != 200 {
                    return Fail<String, LoginError>(error: LoginError.input("some error")).eraseToAnyPublisher()
                   
                } else {
                    return Just("").setFailureType(to: LoginError.self).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }}
}

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
    public static func make(remote: @escaping Remote) -> LoginViewModel {
        let submitter = makeSubmitter(remote: remote)
        let viewModel = LoginViewModel(submitter: submitter)
        return viewModel
    }
    
    private static func makeSubmitter(remote: @escaping Remote) -> LoginSubmitter {{ _ in
        remote(URLRequest(url: URL(string: "https://any.com")!))
            .map { _ in "" }
            .eraseToAnyPublisher()
    }}
}

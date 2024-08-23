//
//  LoginFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Foundation

typealias LoginFeature = LoginViewModel

struct LoginEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
}

struct LoginEvents {
    let onSuccessfulSubmitLogin: (LoginModel) -> Void
    let onGoogleOAuthButtonTapped: () -> Void
    let onRegisterButtonTapped: () -> Void
}

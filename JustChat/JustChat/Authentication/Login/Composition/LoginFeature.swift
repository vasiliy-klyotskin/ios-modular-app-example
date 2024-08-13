//
//  LoginFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Foundation

struct LoginFeature {
    let submitVm: LoginViewModel
    let inputVm: TextFieldViewModel
    let toastVm: ToastViewModel
    let events: LoginEvents
}

struct LoginEnvironment {
    let httpClient: RemoteClient
    let currentTime: () -> Date
    let scheduler: AnySchedulerOf<DispatchQueue>
}

public struct LoginEvents {
    let onSuccessfulSubmitLogin: (LoginModel) -> Void
    let onGoogleOAuthButtonTapped: () -> Void
    let onRegisterButtonTapped: () -> Void
}

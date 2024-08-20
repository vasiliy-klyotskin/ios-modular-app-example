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
    let scheduler: AnySchedulerOf<DispatchQueue>
    
    init(
        httpClient: @escaping RemoteClient,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.httpClient = httpClient
        self.scheduler = scheduler
    }
}

struct LoginEvents {
    let onSuccessfulSubmitLogin: (LoginModel) -> Void
    let onGoogleOAuthButtonTapped: () -> Void
    let onRegisterButtonTapped: () -> Void
}

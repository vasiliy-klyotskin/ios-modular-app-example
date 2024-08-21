//
//  RegisterFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation

struct RegisterFeature {
    let emailInputVm: TextFieldViewModel
    let usernameInputVm: TextFieldViewModel
    let toastVm: ToastViewModel
    let registerVm: RegisterViewModel
    let events: RegisterEvents
}

struct RegisterEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
}

struct RegisterEvents {
    let onSuccessfulSubmitRegister: (RegisterModel) -> Void
    let onLoginButtonTapped: () -> Void
}

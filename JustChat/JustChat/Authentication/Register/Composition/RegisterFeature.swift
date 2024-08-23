//
//  RegisterFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation

typealias RegisterFeature = RegisterViewModel

struct RegisterEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
}

struct RegisterEvents {
    let onSuccessfulSubmitRegister: (RegisterModel) -> Void
    let onLoginButtonTapped: () -> Void
}

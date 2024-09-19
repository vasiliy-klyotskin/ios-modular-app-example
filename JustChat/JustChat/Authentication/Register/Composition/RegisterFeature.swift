//
//  RegisterFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation

typealias RegisterFeature = RegisterViewModel

struct RegisterEvents {
    let onSuccessfulSubmitRegister: (RegisterModel) -> Void
    let onLoginButtonTapped: () -> Void
}

struct RegisterEnvironment {
    let remoteClient: RemoteClient
    let uiScheduler: AnySchedulerOf<DispatchQueue>
    let toast: ToastViewModel
    
    static func from(resolver: Resolver) -> Self {
        .init(
            remoteClient: resolver.remoteClient,
            uiScheduler: resolver.uiScheduler,
            toast: resolver.appToast
        )
    }
}

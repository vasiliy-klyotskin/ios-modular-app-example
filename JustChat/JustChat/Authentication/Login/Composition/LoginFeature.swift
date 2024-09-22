//
//  LoginFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Foundation

typealias LoginFeature = LoginViewModel

struct LoginEvents {
    let onSuccessfulSubmitLogin: (LoginModel) -> Void
    let onGoogleSignInButtonTapped: () -> Void
    let onRegisterButtonTapped: () -> Void
}

struct LoginEnvironment {
    let remoteClient: RemoteClient
    let uiScheduler: AnySchedulerOf<DispatchQueue>
    let toast: ToastFeature
    
    static func from(resolver: Resolver) -> Self {
        .init(
            remoteClient: resolver.remoteClient,
            uiScheduler: resolver.uiScheduler,
            toast: resolver.appToast
        )
    }
}

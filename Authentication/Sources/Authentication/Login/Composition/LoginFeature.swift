//
//  LoginFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Foundation
import Networking
import CompositionSupport
import Primitives

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
            remoteClient: resolver.defaultRemoteClient,
            uiScheduler: resolver.defaultUIScheduler,
            toast: resolver.defaultAppToast
        )
    }
}

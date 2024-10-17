//
//  RegisterFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Foundation
import Primitives
import Networking
import CompositionSupport

typealias RegisterFeature = RegisterViewModel

struct RegisterEvents {
    let onSuccessfulSubmitRegister: (RegisterModel) -> Void
    let onLoginButtonTapped: () -> Void
}

struct RegisterEnvironment {
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

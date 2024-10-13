//
//  EnterCodeFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Foundation
import CompositionSupport
import Primitives
import Networking

typealias EnterCodeFeature = EnterCodeViewModel

struct EnterCodeEvents {
    let onCorrectOtpEnter: (EnterCodeSubmitModel) -> Void
}

struct EnterCodeEnvironment {
    let remoteClient: RemoteClient
    let uiScheduler: AnySchedulerOf<DispatchQueue>
    let toast: ToastFeature
    let makeTimer: MakeTimer
    
    static func from(resolver: Resolver) -> Self {
        .init(
            remoteClient: resolver.defaultRemoteClient,
            uiScheduler: resolver.defaultUIScheduler,
            toast: resolver.defaultAppToast,
            makeTimer: resolver.get(MakeTimer.self)
        )
    }
}

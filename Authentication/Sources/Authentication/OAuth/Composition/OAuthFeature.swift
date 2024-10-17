//
//  OAuthFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation
import Networking
import CompositionSupport
import Primitives

typealias OAuthFeature = OAuthViewModel

struct OAuthEvents {
    let onSuccess: (OAuthModel) -> Void
}

struct OAuthEnvironment {
    let remoteClient: RemoteClient
    let uiScheduler: AnySchedulerOf<DispatchQueue>
    let toast: ToastFeature
    let appInfo: AppInfo
    let makeAuthSession: MakeAuthSession
    
    static func from(resolver: Resolver) -> Self {
        .init(
            remoteClient: resolver.defaultRemoteClient,
            uiScheduler: resolver.defaultUIScheduler,
            toast: resolver.defaultAppToast,
            appInfo: resolver.get(AppInfo.self),
            makeAuthSession: resolver.get(MakeAuthSession.self)
        )
    }
}

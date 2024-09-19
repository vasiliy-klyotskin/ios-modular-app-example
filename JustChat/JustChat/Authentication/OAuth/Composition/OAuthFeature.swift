//
//  OAuthFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation

typealias OAuthFeature = OAuthViewModel

struct OAuthEvents {
    let onSuccess: (OAuthModel) -> Void
}

struct OAuthEnvironment {
    let remoteClient: RemoteClient
    let uiScheduler: AnySchedulerOf<DispatchQueue>
    let toast: ToastViewModel
    let appInfo: AppInfo
    let makeAuthSession: MakeAuthSession
    
    static func from(resolver: Resolver) -> Self {
        .init(
            remoteClient: resolver.remoteClient,
            uiScheduler: resolver.uiScheduler,
            toast: resolver.appToast,
            appInfo: resolver.get(AppInfo.self),
            makeAuthSession: resolver.get(MakeAuthSession.self)
        )
    }
}

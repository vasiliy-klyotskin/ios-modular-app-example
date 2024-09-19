//
//  JustChatApp.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import SwiftUI
import Combine
import AuthenticationServices

@main
struct JustChatApp: App {
    static let toast = ToastViewModel.make(uiScheduler: .main)
    static let container = Container()
        .register(AppInfo.self, .init(bundleId: Bundle.main.bundleIdentifier ?? ""))
        .register(RemoteClient.self, AuthenticationDemoRemote().load)
        .register(AnySchedulerOf<DispatchQueue>.self, .main)
        .register(ToastViewModel.self, toast)
        .register(MakeTimer.self, Timer.scheduledOnMainRunLoop)
        .register(MakeAuthSession.self, ASWebAuthenticationSession.init)
        .register(KeychainStorage.self, .init(service: "Authentication"))
    
    static let feature = AuthenticationFeature.make(
        env: .from(resolver: container), events: .init(onSuccess: { print( "Here we go!" )} )
    )
    
    var body: some Scene {
        WindowGroup {
            Self.feature.view()
                .showToast(Toast(vm: Self.toast))
        }
    }
}

final class AuthenticationDemoRemote {
    func load(for request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        if request.path == LoginRequest.path {
            return Just(LoginData.successResponse(token: "any", otpLength: 5))
                .setFailureType(to: Swift.Error.self)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return Just(apiError(messages: ["ANY": "Error!"]))
                .setFailureType(to: Swift.Error.self)
                .delay(for: 2, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

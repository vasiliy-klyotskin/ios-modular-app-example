//
//  OAuth+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Combine

extension OAuthFeature {
    func view() -> OAuthView { .init(vm: self) }
    
    static func make(env: OAuthEnvironment, events: OAuthEvents) -> OAuthFeature {
        let oAuth = OAuthService(
            provider: PresentationContextProvider(),
            bundleId: env.appInfo.bundleId,
            makeAuthSession: env.makeAuthSession
        )
        let vm = OAuthViewModel(toast: env.toast)
        vm.onNeedStartGoogleSignIn = oAuth.startGoogleSignIn
        oAuth.onGoogleSignInSuccess = start(getTokens <~ env <~ events <~ vm)
        return vm
    }
    
    private static func getTokens(
        env: OAuthEnvironment,
        events: OAuthEvents,
        vm: Weak<OAuthViewModel>,
        request: OAuthRequest
    ) -> AnyPublisher<OAuthModel, OAuthError> {
        env.remoteClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(OAuthError.fromRemoteError)
            .map(OAuthModel.fromDto)
            .receive(on: env.uiScheduler)
            .onLoadingStart(vm.do { $0.displayLoadingStart })
            .onLoadingFinish(vm.do { $0.displayLoadingFinish })
            .onLoadingFailure(vm.do { $0.displayError })
            .onLoadingSuccess(events.onSuccess)
            .eraseToAnyPublisher()
    }
}
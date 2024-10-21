//
//  Authentication+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import CompositionSupport

extension AuthenticationFeature {
    @MainActor
    public static func make(env: AuthenticationEnvironment, events: AuthenticationEvents) -> AuthenticationFeature {
        let tokenService = AuthTokensService(keychain: env.keychain)
        let weakFlow: Weak<AuthenticationFlow> = .init()
        let loginEvents = LoginEvents(
            onSuccessfulSubmitLogin: { weakFlow.obj?.goToOtp(model: $0) },
            onGoogleSignInButtonTapped: { weakFlow.obj?.showGoogleSignIn() },
            onRegisterButtonTapped: { weakFlow.obj?.goToRegistration() }
        )
        let registerEvents = RegisterEvents(
            onSuccessfulSubmitRegister: { weakFlow.obj?.goToOtp(model: $0) },
            onLoginButtonTapped: { weakFlow.obj?.goBack() }
        )
        let enterCodeEvents = EnterCodeEvents(
            onCorrectOtpEnter:
                firstly(tokenService.save)
                .then(events.onSuccess)
                .map(EnterCodeSubmitModel.from)
                .execute
        )
        let googleOAuthEvents = OAuthEvents(
            onSuccess:
                firstly(tokenService.save)
                .then(events.onSuccess)
                .map(OAuthModel.from)
                .execute
        )
        let flow = AuthenticationFlow(factory: .init(
            login: LoginFeature.make <~ env.login() <~ loginEvents,
            register: RegisterFeature.make <~ env.register() <~ registerEvents,
            googleOAuth: OAuthFeature.make <~ env.oAuth() <~ googleOAuthEvents,
            enterCode: EnterCodeFeature.make <~ env.enterCode() <~ enterCodeEvents
        ))
        weakFlow.obj = flow
        return flow
    }
    
    public func view() -> AuthenticationView {
        .init(flow: self)
    }
}

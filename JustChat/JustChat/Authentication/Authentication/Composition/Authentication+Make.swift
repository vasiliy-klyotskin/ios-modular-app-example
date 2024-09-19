//
//  Authentication+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

extension AuthenticationFeature {
    func view() -> AuthenticationView { .init(flow: self) }
    
    static func make(env: AuthenticationEnvironment, events: AuthenticationEvents) -> AuthenticationFeature {
        let tokenService = AuthTokensService(keychain: env.keychain)
        let weakFlow: Weak<AuthenticationFlow> = .init()
        let loginEvents = LoginEvents(
            onSuccessfulSubmitLogin: weakFlow.do { $0.goToOtp },
            onGoogleSignInButtonTapped: weakFlow.do { $0.showGoogleSignIn },
            onRegisterButtonTapped: weakFlow.do { $0.goToRegistration }
        )
        let registerEvents = RegisterEvents(
            onSuccessfulSubmitRegister: weakFlow.do { $0.goToOtp },
            onLoginButtonTapped: weakFlow.do { $0.goBack }
        )
        let enterCodeEvents = EnterCodeEvents(
            onCorrectOtpEnter: tokenService.save |> events.onSuccess
        )
        let googleOAuthEvents = OAuthEvents(
            onSuccess: tokenService.save |> events.onSuccess
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
}
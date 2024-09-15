//
//  Authentication+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

extension AuthenticationFeature {
    func view() -> AuthenticationView { .init(flow: self) }
    
    static func make(env: AuthenticationEnvironment, events: AuthenticationEvents) -> AuthenticationFeature {
        let tokenService = AuthTokensService(storage: env.storage)
        let weakFlow: Weak<AuthenticationFlow> = .init()
        let loginEvents = LoginEvents(
            onSuccessfulSubmitLogin: weakFlow.do { $0.goToOtp },
            onGoogleOAuthButtonTapped: {},
            onRegisterButtonTapped: weakFlow.do { $0.goToRegistration }
        )
        let registerEvents = RegisterEvents(
            onSuccessfulSubmitRegister: weakFlow.do { $0.goToOtp },
            onLoginButtonTapped: weakFlow.do { $0.goBack }
        )
        let enterCodeEvents = EnterCodeEvents(
            onCorrectOtpEnter: tokenService.save |> events.onSuccess
        )
        let flow = AuthenticationFlow(factory: .init(
            login: LoginFeature.make <~ env.login <~ loginEvents,
            register: RegisterFeature.make <~ env.register <~ registerEvents,
            enterCode: EnterCodeFeature.make <~ env.enterCode <~ enterCodeEvents
        ))
        weakFlow.obj = flow
        return flow
    }
}

//
//  Authentication+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

extension AuthenticationFeature {
    func view() -> AuthenticationView {
        let screens = AuthenticationScreens(
            login: { login().view() },
            register: { register().view() },
            enterCode: { enterCode($0).view() }
        )
        return .init(flow: flow, screens: screens)
    }
    
    static func make(env: AuthenticationEnvironment, events: AuthenticationEvents) -> AuthenticationFeature {
        let flow = AuthenticationFlow()
        let loginEvents = LoginEvents(
            onSuccessfulSubmitLogin: flow.goToOtp,
            onGoogleOAuthButtonTapped: {},
            onRegisterButtonTapped: flow.goToRegistration
        )
        let registerEvents = RegisterEvents(
            onSuccessfulSubmitRegister: flow.goToOtp,
            onLoginButtonTapped: flow.goBack
        )
        let enterCodeEvents = EnterCodeEvents(onCorrectOtpEnter: { _ in })
        let login = LoginFeature.make <~ env.login <~ loginEvents
        let register = RegisterFeature.make <~ env.register <~ registerEvents
        let enterCode = EnterCodeFeature.make <~ env.enterCode <~ enterCodeEvents
        return .init(flow: flow, login: login, register: register, enterCode: enterCode)
    }
}

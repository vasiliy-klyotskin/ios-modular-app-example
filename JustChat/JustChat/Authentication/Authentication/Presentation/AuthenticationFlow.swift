//
//  AuthenticationFlow.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Combine
import Foundation

final class AuthenticationFlow: ObservableObject {
    enum Path: Hashable {
        case register(Screen<RegisterFeature>)
        case enterCode(Screen<EnterCodeFeature>)
    }
    
    struct Factory {
        let login: () -> LoginFeature
        let register: () -> RegisterFeature
        let googleOAuth: () -> OAuthFeature
        let enterCode: (EnterCodeResendModel) -> EnterCodeFeature
    }
    
    lazy var root: LoginFeature = { factory.login() }()
    @Published var googleOAuthFeature: OAuthFeature?
    @Published var path: [Path] = []
    
    private let factory: Factory
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    func showGoogleSignIn() {
        googleOAuthFeature = factory.googleOAuth()
        googleOAuthFeature?.startGoogleSignIn()
    }
    
    func goToRegistration() {
        let registerScreen = Screen(feature: factory.register())
        path.append(.register(registerScreen))
    }
    
    func goToOtp(model: LoginModel) {
        let enterCodeScreen = Screen(feature: factory.enterCode(model.enterCodeModel))
        path.append(.enterCode(enterCodeScreen))
    }
    
    func goToOtp(model: RegisterModel) {
        let enterCodeScreen = Screen(feature: factory.enterCode(model.enterCodeModel))
        path.append(.enterCode(enterCodeScreen))
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

struct Screen<T>: Identifiable, Hashable {
    let id = UUID()
    let feature: T
    
    static func screen(_ feature: T) -> Screen<T> {
        .init(feature: feature)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Screen<T>, rhs: Screen<T>) -> Bool {
        lhs.id == rhs.id
    }
}

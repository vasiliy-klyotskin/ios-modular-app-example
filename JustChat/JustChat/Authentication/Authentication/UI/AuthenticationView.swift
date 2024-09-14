//
//  Navigation.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import SwiftUI

struct AuthenticationScreens {
    let login: () -> LoginView
    let register: () -> RegisterView
    let enterCode: (EnterCodeResendModel) -> EnterCodeView
}

struct AuthenticationView: View {
    @ObservedObject var flow: AuthenticationFlow
    let screens: AuthenticationScreens

    var body: some View {
        NavigationStack(path: $flow.path) {
            screens.login()
                .navigationDestination(for: AuthenticationFlow.Path.self, destination: destination(path:))
        }
    }
    
    @ViewBuilder
    private func destination(path: AuthenticationFlow.Path) -> some View {
        switch path {
        case .enterCode(let model): screens.enterCode(model)
        case .register: screens.register()
        }
    }
}

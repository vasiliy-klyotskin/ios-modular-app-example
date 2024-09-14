//
//  AuthenticationFlow.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Combine

final class AuthenticationFlow: ObservableObject {
    enum Path: Hashable {
        case register
        case enterCode(EnterCodeResendModel)
    }
    
    @Published var path: [Path] = []
    
    func goToRegistration() {
        path.append(.register)
    }
    
    func goToOtp(model: LoginModel) {
        path.append(.enterCode(model.enterCodeModel))
    }
    
    func goToOtp(model: RegisterModel) {
        path.append(.enterCode(model.enterCodeModel))
    }
    
    func goBack() {
        path.removeLast()
    }
}

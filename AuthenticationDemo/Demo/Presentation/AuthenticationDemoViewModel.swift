//
//  AuthenticationDemoViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import Combine
import Authentication

final class AuthenticationDemoViewModel: ObservableObject {
    var onNeedRestart: () -> Void = {}
    
    @Published var showSuccessAlert = false
    private var accessTokenPart = ""
    private var refreshTokenPart = ""
    
    var successTitle: String {
        "Success!"
    }
    var successMessage: String {
        [accessTokenPart, refreshTokenPart].joined(separator: "\n")
    }
    var restartButtonTitle: String {
        "Restart"
    }
    
    func showSuccess(model: AuthenticationTokens) {
        accessTokenPart = "Access token: " + model.accessToken
        refreshTokenPart = "Refresh token: " + model.refreshToken
        showSuccessAlert = true
    }
    
    func restart() {
        onNeedRestart()
    }
}

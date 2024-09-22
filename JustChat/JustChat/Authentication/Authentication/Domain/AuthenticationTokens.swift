//
//  AuthenticationTokens.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

struct AuthenticationTokens: Equatable {
    let accessToken: String
    let refreshToken: String
}

extension EnterCodeSubmitModel {
    static func from(model: EnterCodeSubmitModel) -> AuthenticationTokens {
        .init(accessToken: model.accessToken, refreshToken: model.refreshToken)
    }
}

extension OAuthModel {
    static func from(model: OAuthModel) -> AuthenticationTokens {
        .init(accessToken: model.accessToken, refreshToken: model.refreshToken)
    }
}

//
//  AuthenticationTokens.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

public struct AuthenticationTokens: Equatable {
    public let accessToken: String
    public let refreshToken: String
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

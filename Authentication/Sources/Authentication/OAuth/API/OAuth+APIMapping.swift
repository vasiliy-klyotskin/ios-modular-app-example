//
//  OAuth+APIMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/16/24.
//

import Networking

struct OAuthDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension OAuthModel {
    static func fromDto(from dto: OAuthDTO) -> OAuthModel {
        .init(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}

extension OAuthError {
    static func fromRemoteError(_ remoteError: RemoteError) -> OAuthError {
        switch remoteError {
        case .system(let error):
            return .init(message: error)
        case .messages(let messagesError):
            return from(messagesError: messagesError)
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> OAuthError {
        if let generalMessage = messagesError.messages[generalKey] {
            return .init(message: generalMessage)
        } else {
            return .init(message: messagesError.fallback)
        }
    }
    
    static var generalKey: String { "OAUTH_GENERAL" }
}

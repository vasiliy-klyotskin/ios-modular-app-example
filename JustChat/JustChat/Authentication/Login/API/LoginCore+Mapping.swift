//
//  LoginRemoteMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension LoginModel {
    static func fromLoginAndDto(login: String, dto: LoginResponseDTO) -> LoginModel {
        .init(login: login, confirmationToken: dto.confirmationToken, otpLength: dto.otpLength, nextAttemptAfter: dto.nextAttemptAfter)
    }
}

extension LoginError {
    static func fromRemoteError(_ remoteError: RemoteError) -> LoginError {
        switch remoteError {
        case .system(let error):
            return .general(error)
        case .messages(let messagesError):
            return from(messagesError: messagesError)
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> LoginError {
        if let inputMessage = messagesError.messages["LOGIN_INPUT"] {
            return .input(inputMessage)
        } else {
            return .general(messagesError.fallback)
        }
    }
}

//
//  LoginRemoteMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation
import Networking

struct LoginResponseDTO: Decodable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension LoginModel {
    static func fromDto(dto: LoginResponseDTO) -> LoginModel {
        .init(confirmationToken: dto.confirmationToken, otpLength: dto.otpLength, nextAttemptAfter: dto.nextAttemptAfter)
    }
}

extension LoginError {
    static func fromRemoteError(_ remoteError: RemoteError) -> LoginError {
        switch remoteError {
        case .system(let error):
            return .general(error)
        case .messages(let messagesError):
            return from(messagesError: messagesError)
        @unknown default:
            fatalError()
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> LoginError {
        if let inputMessage = messagesError.messages[inputKey] {
            return .input(inputMessage)
        } else if let generalMessage = messagesError.messages[generalKey] {
            return .general(generalMessage)
        } else {
            return .general(messagesError.fallback)
        }
    }
    
    static var inputKey: String { "LOGIN_INPUT" }
    static var generalKey: String { "LOGIN_GENERAL" }
}

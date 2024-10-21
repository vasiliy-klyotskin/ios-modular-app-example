//
//  Register+APIMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Networking

struct RegisterResponseDTO: Decodable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension RegisterModel {
    static func fromDto(dto: RegisterResponseDTO) -> RegisterModel {
        .init(confirmationToken: dto.confirmationToken, otpLength: dto.otpLength, nextAttemptAfter: dto.nextAttemptAfter)
    }
}

extension RegisterError {
    static func fromRemoteError(_ error: RemoteError) -> RegisterError {
        switch error {
        case .system(let error):
            return .general(error)
        case .messages(let messages):
            return from(messagesError: messages)
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> RegisterError {
        var validations: [Validation] = []
        messagesError.messages[emailKey].map { validations.append(.email($0)) }
        messagesError.messages[usernameKey].map { validations.append(.username($0)) }
        if validations.isEmpty {
            let generalError = messagesError.messages[generalKey]
            return .general(generalError ?? messagesError.fallback)
        } else {
            return .validation(validations)
        }
    }
    
    static var emailKey: String { "REGISTER_EMAIL" }
    static var usernameKey: String { "REGISTER_USERNAME" }
    static var generalKey: String { "REGISTER_GENERAL" }
}

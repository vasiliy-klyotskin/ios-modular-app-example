//
//  Register+APIMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

struct RegisterResponseDTO {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension RegisterModel {
    static func fromEmailAndDto(email: String, dto: RegisterResponseDTO) -> RegisterModel {
        .init(email: email, confirmationToken: dto.confirmationToken, otpLength: dto.otpLength, nextAttemptAfter: dto.nextAttemptAfter)
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
        return .general("")
//        if let inputMessage = messagesError.messages[inputKey] {
//            return .input(inputMessage)
//        } else {
//            return .general(messagesError.fallback)
//        }
    }
}

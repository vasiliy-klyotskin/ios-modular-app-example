//
//  EnterCodeResend+APIMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

import Foundation

struct EnterCodeResendDTO: Decodable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension EnterCodeResendModel {
    static func fromDto(from dto: EnterCodeResendDTO) -> EnterCodeResendModel {
        .init(confirmationToken: dto.confirmationToken, otpLength: dto.otpLength, nextAttemptAfter: dto.nextAttemptAfter)
    }
}

extension EnterCodeResendError {
    static func fromRemoteError(_ remoteError: RemoteError) -> EnterCodeResendError {
        switch remoteError {
        case .system(let error):
            return .init(message: error)
        case .messages(let messagesError):
            return from(messagesError: messagesError)
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> EnterCodeResendError {
        if let generalMessage = messagesError.messages[generalKey] {
            return .init(message: generalMessage)
        } else {
            return .init(message: messagesError.fallback)
        }
    }
    
    static var generalKey: String { "ENTER_CODE_RESEND_GENERAL" }
}

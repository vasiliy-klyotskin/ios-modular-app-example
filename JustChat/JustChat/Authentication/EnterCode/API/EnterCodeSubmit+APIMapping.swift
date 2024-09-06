//
//  EnterCodeSubmit+APIMapping.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

import Foundation

struct EnterCodeSubmitDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension EnterCodeSubmitModel {
    static func fromDto(from dto: EnterCodeSubmitDTO) -> EnterCodeSubmitModel {
        .init(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}

extension EnterCodeSubmitError {
    static func fromRemoteError(_ remoteError: RemoteError) -> EnterCodeSubmitError {
        switch remoteError {
        case .system(let error):
            return .general(error)
        case .messages(let messagesError):
            return from(messagesError: messagesError)
        }
    }
    
    private static func from(messagesError: RemoteMessagesError) -> EnterCodeSubmitError {
        if let generalMessage = messagesError.messages[generalKey] {
            return .general(generalMessage)
        } else if let validationMessage = messagesError.messages[validationKey] {
            return .validation(validationMessage)
        } else {
            return .general(messagesError.fallback)
        }
    }
    
    static var generalKey: String { "ENTER_CODE_SUBMIT_GENERAL" }
    static var validationKey: String { "ENTER_CODE_SUBMIT_VALIDATION" }
}

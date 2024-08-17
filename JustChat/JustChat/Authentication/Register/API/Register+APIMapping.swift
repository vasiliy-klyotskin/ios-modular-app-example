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

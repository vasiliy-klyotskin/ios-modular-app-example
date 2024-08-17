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

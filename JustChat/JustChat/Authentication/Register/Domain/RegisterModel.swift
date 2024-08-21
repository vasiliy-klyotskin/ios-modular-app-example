//
//  RegisterModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

struct RegisterModel: Equatable {
    let request: RegisterRequest
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

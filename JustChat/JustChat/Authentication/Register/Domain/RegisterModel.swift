//
//  RegisterModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

struct RegisterModel: Equatable {
    let email: String
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

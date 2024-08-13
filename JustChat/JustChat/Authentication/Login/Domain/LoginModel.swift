//
//  LoginModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

struct LoginModel: Equatable {
    let login: String
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

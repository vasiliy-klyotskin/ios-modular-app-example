//
//  LoginModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

public struct LoginModel: Equatable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

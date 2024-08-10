//
//  LoginModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

public struct LoginModel: Equatable {
    let login: String
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
    
    public init(login: String, confirmationToken: String, otpLength: Int, nextAttemptAfter: Int) {
        self.login = login
        self.confirmationToken = confirmationToken
        self.otpLength = otpLength
        self.nextAttemptAfter = nextAttemptAfter
    }
}

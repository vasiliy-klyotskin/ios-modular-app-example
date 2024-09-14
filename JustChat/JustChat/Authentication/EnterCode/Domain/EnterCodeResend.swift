//
//  EnterCodeResend.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

struct EnterCodeResendModel: Hashable {
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
}

extension LoginModel {
    var enterCodeModel: EnterCodeResendModel {
        .init(confirmationToken: confirmationToken, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
}

extension RegisterModel {
    var enterCodeModel: EnterCodeResendModel {
        .init(confirmationToken: confirmationToken, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
}

struct EnterCodeResendRequest {
    let confirmationToken: String
}

struct EnterCodeResendError: Error {
    let message: String
}

//
//  EnterCodeResend+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

struct EnterCodeResendRequestDTO: Encodable, Equatable {
    let confirmationToken: String
}

extension EnterCodeResendRequest {
    var remote: RemoteRequest {
        let path = "resend-otp"
        let method = "POST"
        let dto = EnterCodeResendRequestDTO(confirmationToken: self.confirmationToken)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}

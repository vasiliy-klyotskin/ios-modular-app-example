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
    static var path: String { "resend-otp" }
    static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = EnterCodeResendRequestDTO(confirmationToken: self.confirmationToken)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

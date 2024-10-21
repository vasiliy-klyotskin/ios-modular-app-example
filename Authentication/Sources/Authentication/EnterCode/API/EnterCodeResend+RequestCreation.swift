//
//  EnterCodeResend+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

import Networking

public struct EnterCodeResendRequestDTO: Encodable, Equatable {
    let confirmationToken: String
}

extension EnterCodeResendRequest {
    public static var path: String { "resend-otp" }
    public static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = EnterCodeResendRequestDTO(confirmationToken: self.confirmationToken)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

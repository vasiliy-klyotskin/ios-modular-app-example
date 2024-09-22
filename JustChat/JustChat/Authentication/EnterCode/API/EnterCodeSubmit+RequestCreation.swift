//
//  EnterCodeSubmit+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

struct EnterCodeSubmitRequestDTO: Encodable, Equatable {
    let code: String
    let confirmationToken: String
}

extension EnterCodeSubmitRequest {
    static var path: String { "submit-otp" }
    static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = EnterCodeSubmitRequestDTO(code: code, confirmationToken: confirmationToken)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

//
//  EnterCodeSubmit+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/30/24.
//

struct EnterCodeSubmitRequestDTO: Encodable, Equatable {
    let code: String
}

extension EnterCodeSubmitRequest {
    var remote: RemoteRequest {
        let path = "submit-otp"
        let method = "POST"
        let dto = EnterCodeSubmitRequestDTO(code: code)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}
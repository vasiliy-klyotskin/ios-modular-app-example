//
//  Register+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

struct RegisterRequestDTO: Encodable {
    let email: String
    let username: String
}

extension RegisterRequest {
    func remoteRequest(with encode: RemoteEncoder<RegisterRequestDTO>) -> RemoteRequest {
        let path = "register"
        let method = "POST"
        let body = encode(RegisterRequestDTO(email: email, username: username))
        return .init(path: path, method: method, body: body)
    }
}

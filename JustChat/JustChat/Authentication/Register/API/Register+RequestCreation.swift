//
//  Register+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

struct RegisterRequestDTO: Encodable, Equatable {
    let email: String
    let username: String
}

extension RegisterRequest {
    var remote: RemoteRequest {
        let path = "register"
        let method = "POST"
        let dto = RegisterRequestDTO(email: email, username: username)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}

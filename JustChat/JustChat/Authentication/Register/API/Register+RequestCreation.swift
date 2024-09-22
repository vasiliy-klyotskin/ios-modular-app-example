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
    static var path: String { "register" }
    static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = RegisterRequestDTO(email: email, username: username)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

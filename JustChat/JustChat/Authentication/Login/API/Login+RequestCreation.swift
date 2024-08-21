//
//  LoginRequest+Creation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

struct LoginRequestDTO: Encodable, Equatable {
    let login: String
}

extension LoginRequest {
    var remote: RemoteRequest {
        let path = "login"
        let method = "POST"
        let dto = LoginRequestDTO(login: self)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}

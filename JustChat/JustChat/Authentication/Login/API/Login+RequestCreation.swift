//
//  LoginRequest+Creation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let login: String
}

extension LoginRequest {
    var urlRequest: RemoteRequest {
        let path = "login"
        let method = "POST"
        let body = try? JSONEncoder().encode(LoginRequestDTO(login: self))
        return .init(path: path, method: method, body: body)
    }
}

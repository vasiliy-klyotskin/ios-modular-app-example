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
    static var path: String { "login" }
    
    var remote: RemoteRequest {
        let path = Self.path
        let method = "POST"
        let dto = LoginRequestDTO(login: self)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}

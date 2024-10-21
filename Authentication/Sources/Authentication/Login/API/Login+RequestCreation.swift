//
//  LoginRequest+Creation.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation
import Networking

struct LoginRequestDTO: Encodable, Equatable {
    let login: String
}

extension LoginRequest {
    public static var path: String { "login" }
    public static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = LoginRequestDTO(login: self)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

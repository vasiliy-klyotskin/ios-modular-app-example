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
    var urlRequest: URLRequest {
        let url = URL(string: "https://justchat.com/api/v1/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(LoginRequestDTO(login: self))
        return request
    }
}

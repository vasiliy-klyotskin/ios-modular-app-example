//
//  OAuth+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/16/24.
//

import Networking

struct OAuthRequestDTO: Encodable, Equatable {
    let authCode: String
}

extension OAuthRequest {
    public static var path: String { "oauth/google" }
    public static var method: String { "POST" }
    
    var remote: RemoteRequest {
        let dto = OAuthRequestDTO(authCode: authCode)
        return .init(path: Self.path, method: Self.method, body: .encodable(dto))
    }
}

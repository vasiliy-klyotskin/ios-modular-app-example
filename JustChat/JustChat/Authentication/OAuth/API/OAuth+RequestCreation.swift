//
//  OAuth+RequestCreation.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/16/24.
//

struct OAuthRequestDTO: Encodable, Equatable {
    let authCode: String
}

extension OAuthRequest {
    var remote: RemoteRequest {
        let path = "oauth/google"
        let method = "POST"
        let dto = OAuthRequestDTO(authCode: authCode)
        return .init(path: path, method: method, body: .encodable(dto))
    }
}

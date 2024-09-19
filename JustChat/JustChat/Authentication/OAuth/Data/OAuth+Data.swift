//
//  OAuth+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

import Foundation

enum OAuthData {
    static func successResponse(accessToken: String, refreshToken: String) -> RemoteResponse {
        let json = """
        {
            "accessToken": "\(accessToken)",
            "refreshToken": "\(refreshToken)"
        }
        """
        return apiSuccess(json: json)
    }
    
    static func generalErrorResponse(message: String) -> RemoteResponse {
        apiError(messages: [OAuthError.generalKey: message])
    }
    
    static func redirectUrlWith(code: String) -> String {
        "any:/anyPath?code=\(code)"
    }
}

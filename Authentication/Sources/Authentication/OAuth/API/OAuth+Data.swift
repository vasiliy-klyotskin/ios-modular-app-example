//
//  OAuth+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

import Foundation
import Networking

public enum OAuthData {
    public static func successResponse(accessToken: String, refreshToken: String) -> RemoteResponse {
        let json = """
        {
            "accessToken": "\(accessToken)",
            "refreshToken": "\(refreshToken)"
        }
        """
        return apiSuccess(json: json)
    }
    
    public static func generalErrorResponse(message: String) -> RemoteResponse {
        apiError(messages: [OAuthError.generalKey: message])
    }
    
    public static func redirectUrlWith(code: String) -> String {
        "any:/anyPath?code=\(code)"
    }
}

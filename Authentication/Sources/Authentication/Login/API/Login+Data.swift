//
//  Login+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation
import Networking

public enum LoginData {
    public static func successResponse(token: String, otpLength: Int, next: Int = 60) -> RemoteResponse {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
                
    public static func successModel(token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> LoginModel {
        .init(confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
    
    public static func inputError(_ error: String) -> RemoteResponse {
        apiError(messages: [LoginError.inputKey: error])
    }
    
    public static func generalError(_ error: String) -> RemoteResponse {
        apiError(messages: [LoginError.generalKey: error])
    }
}

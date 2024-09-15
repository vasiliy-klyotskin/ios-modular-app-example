//
//  Login+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation
@testable import JustChat

enum LoginData {
    static func successResponse(token: String, otpLength: Int, next: Int = 60) -> (Data, HTTPURLResponse) {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
                
    static func successModel(token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> LoginModel {
        .init(confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
    
    static func inputError(_ error: String) -> RemoteResponse {
        apiError(messages: [LoginError.inputKey: error])
    }
    
    static func generalError(_ error: String) -> RemoteResponse {
        apiError(messages: [LoginError.generalKey: error])
    }
}

//
//  EnterCode+.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

@testable import JustChat

enum EnterCodeData {
    static func successResendResponse(token: String, otpLength: Int, next: Int = 60) -> RemoteResponse {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
    
    static func successSubmitResponse(accessToken: String, refreshToken: String) -> RemoteResponse {
        let json = """
        {
            "accessToken": "\(accessToken)",
            "refreshToken": "\(refreshToken)"
        }
        """
        return apiSuccess(json: json)
    }
                
    static func successModel(access: String, refresh: String) -> EnterCodeSubmitModel {
        .init(accessToken: access, refreshToken: refresh)
    }
    
    static func submitValidationError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.validationKey: error])
    }
    
    static func submitGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.generalKey: error])
    }
    
    static func resendGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeResendError.generalKey: error])
    }
}

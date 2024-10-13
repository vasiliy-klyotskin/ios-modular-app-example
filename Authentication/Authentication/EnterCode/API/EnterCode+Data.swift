//
//  EnterCode+.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Networking

public enum EnterCodeData {
    public static func successResendResponse(token: String, otpLength: Int, next: Int = 60) -> RemoteResponse {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
    
    public static func successSubmitResponse(accessToken: String, refreshToken: String) -> RemoteResponse {
        let json = """
        {
            "accessToken": "\(accessToken)",
            "refreshToken": "\(refreshToken)"
        }
        """
        return apiSuccess(json: json)
    }
                
    public static func successModel(access: String, refresh: String) -> EnterCodeSubmitModel {
        .init(accessToken: access, refreshToken: refresh)
    }
    
    public static func submitValidationError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.validationKey: error])
    }
    
    public static func submitGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.generalKey: error])
    }
    
    public static func resendGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeResendError.generalKey: error])
    }
}

//
//  EnterCode+TestData.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

@testable import JustChat
import Testing
import Foundation

extension EnterCodeTests {
    func expectResendRequestIsCorrect(_ request: RemoteRequest, for token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "resend-otp", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeResendRequestDTO(confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
    
    func expectSubmitRequestIsCorrect(_ request: RemoteRequest, code: String, token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "submit-otp", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeSubmitRequestDTO(code: code, confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
    
    func successResendResponse(token: String, otpLength: Int, next: Int = 60) -> RemoteResponse {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
    
    func successSubmitResponse(accessToken: String, refreshToken: String) -> RemoteResponse {
        let json = """
        {
            "accessToken": "\(accessToken)",
            "refreshToken": "\(refreshToken)"
        }
        """
        return apiSuccess(json: json)
    }
                
    func successModel(access: String, refresh: String) -> EnterCodeSubmitModel {
        .init(accessToken: access, refreshToken: refresh)
    }
    
    func submitValidationError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.validationKey: error])
    }
    
    func submitGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeSubmitError.generalKey: error])
    }
    
    func resendGeneralError(_ error: String) -> RemoteResponse {
        apiError(messages: [EnterCodeResendError.generalKey: error])
    }
}

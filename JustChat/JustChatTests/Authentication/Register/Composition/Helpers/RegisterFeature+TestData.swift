//
//  RegisterFeature+TestData.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
import Testing
@testable import JustChat

extension RegisterFeatureTests {
    func expectRequestIsCorrect(_ request: RemoteRequest, for email: String, username: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "register", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == RegisterRequestDTO(email: email, username: username), comment, sourceLocation: sourceLocation)
    }
    
    func apiSuccessResponse(token: String, otpLength: Int, next: Int = 60) -> RemoteResponse {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
    
    func apiErrorResponse(email: String, username: String) -> RemoteResponse {
        let messages = [RegisterError.emailKey: email, RegisterError.usernameKey: username]
        return apiError(messages: messages)
    }
                
    func successModel(email: String = "", username: String = "", token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> RegisterModel {
        .init(request: .init(email: email, username: username), confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
}

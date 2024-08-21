//
//  Login+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Testing
@testable import JustChat

extension LoginFeatureTests {
    func expectRequestIsCorrect(_ request: RemoteRequest, for login: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "login", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == LoginRequestDTO(login: login), comment, sourceLocation: sourceLocation)
    }
    
    func successResponse(token: String, otpLength: Int, next: Int = 60) -> (Data, HTTPURLResponse) {
        let json = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """
        return apiSuccess(json: json)
    }
                
    func successModel(login: String = "", token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> LoginModel {
        .init(login: login, confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
    
    func inputError(_ error: String) -> (Data, HTTPURLResponse) {
        let messages = [LoginError.inputKey: error]
        return apiError(messages: messages)
    }
}

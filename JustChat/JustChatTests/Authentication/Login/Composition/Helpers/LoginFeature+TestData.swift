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
        #expect(request.bodyData == requestBody(for: login), comment, sourceLocation: sourceLocation)
    }
    
    func requestBody(for login: String) -> Data {
        "{\"login\":\"\(login)\"}".data(using: .utf8)!
    }
    
    func successResponse(token: String, otpLength: Int, next: Int = 60) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = """
        {
            "confirmationToken": "\(token)",
            "nextAttemptAfter": \(next),
            "otpLength": \(otpLength)
        }
        """.data(using: .utf8)!
        return (data, response)
    }
                
    func successModel(login: String = "", token: String = "", otpLength: Int = 0, nextAttemptAfter: Int = 0) -> LoginModel {
        .init(login: login, confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttemptAfter)
    }
    
    func inputError(_ error: String) -> (Data, HTTPURLResponse) {
        let non2xx = 400
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: non2xx, httpVersion: nil, headerFields: nil)!
        let data = """
            {
                "messages": {
                    "\(LoginError.inputKey)": "\(error)"
                }
            }
        """.data(using: .utf8)!
        return (data, response)
    }
}

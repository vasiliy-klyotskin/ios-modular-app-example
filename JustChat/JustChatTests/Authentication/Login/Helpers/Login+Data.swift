//
//  Login+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Testing
import JustChat

extension LoginTests {
    func expectRequestCorrect(_ request: URLRequest, for login: String, _ comment: Comment?) {
        #expect(request.url?.absoluteString == "https://justchat.com/api/v1/login", comment)
        #expect(request.allHTTPHeaderFields == ["Content-Type": "application/json"], comment)
        #expect(request.httpMethod == "POST", comment)
        #expect(request.httpBody == body(for: login), comment)
    }
    
    func body(for login: String) -> Data {
        "{\"login\":\"\(login)\"}".data(using: .utf8)!
    }
    
    func success(token: String, otpLength: Int, next: Int = 60) -> (Data, HTTPURLResponse) {
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
    
    func input(error: String) -> (Data, HTTPURLResponse) {
        let non2xx = 400
        let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: non2xx, httpVersion: nil, headerFields: nil)!
        let data = """
            {
                "messages": {
                    "LOGIN_INPUT": "\(error)"
                }
            }
        """.data(using: .utf8)!
        return (data, response)
    }
}
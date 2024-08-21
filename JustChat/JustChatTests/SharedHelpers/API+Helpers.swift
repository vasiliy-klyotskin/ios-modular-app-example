//
//  API+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
@testable import JustChat

extension RemoteRequest {
    func dto<T: Encodable>() -> T? {
        if case let .encodable(encodable) = body, let dto = encodable as? T {
            return dto
        } else {
            return nil
        }
    }
}

func apiError(messages: [String: String], code: Int = 400) -> RemoteResponse {
    let response = HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!

    let messagesJSON = messages.map { key, value in
        "\"\(key)\": \"\(value)\""
    }.joined(separator: ", ")
    
    let data = """
        {
            "messages": {
                \(messagesJSON)
            }
        }
    """.data(using: .utf8)!
    
    return (data, response)
}

func apiSuccess(json: String, code: Int = 200, url: URL? = nil) -> RemoteResponse {
    let response = HTTPURLResponse(url: url ?? URL(string: "https://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    let data = json.data(using: .utf8)!
    return (data, response)
}

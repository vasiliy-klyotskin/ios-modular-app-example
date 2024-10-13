//
//  RemoteClient+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/19/24.
//

import Foundation

public func apiError(messages: [String: String], code: Int = 400) -> RemoteResponse {
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

public func apiSuccess(json: String, code: Int = 200, url: URL? = nil) -> RemoteResponse {
    let response = HTTPURLResponse(url: url ?? URL(string: "https://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    let data = json.data(using: .utf8)!
    return (data, response)
}

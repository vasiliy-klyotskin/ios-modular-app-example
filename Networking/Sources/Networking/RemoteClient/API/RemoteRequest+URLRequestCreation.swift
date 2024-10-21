//
//  RemoteRequest.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/19/24.
//

import Foundation

extension RemoteRequest {
    var request: URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.httpBody = bodyData
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        return request
    }
    
    var bodyData: Data? {
        switch body {
        case .encodable(let encodable):
            return try? JSONEncoder().encode(encodable)
        case .plain(let data):
            return data
        case .noBody:
            return nil
        }
    }
    
    private var baseURL: URL {
        URL(string: "https://just-chat.com")!
    }
}

//
//  RemoteError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

@frozen public enum RemoteError: Error {
    case system(String)
    case messages(RemoteMessagesError)
}

public struct RemoteMessagesError: Sendable {
    public let messages: [String: String]
    public let fallback: String
    
    public init(messages: [String : String], fallback: String) {
        self.messages = messages
        self.fallback = fallback
    }
}

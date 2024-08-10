//
//  RemoteError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

enum RemoteError: Error {
    case system(String)
    case messages(RemoteMessagesError)
}

struct RemoteMessagesError {
    let messages: [String: String]
    let fallback: String
}

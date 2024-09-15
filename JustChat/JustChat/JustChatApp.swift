//
//  JustChatApp.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import SwiftUI
import Combine

@main
struct JustChatApp: App {
    static let demoHttpClient = AuthenticationDemoRemote()
    static let feature = AuthenticationFeature.make(
        env: .init(
            httpClient: demoHttpClient.load,
            scheduler: .main,
            makeTimer: Timer.scheduledOnMainRunLoop,
            storage: .init(service: "any")
        ), events: .init(onSuccess: { print("Here we go") })
    )
    
    var body: some Scene {
        WindowGroup {
            Self.feature.view()
        }
    }
}

final class AuthenticationDemoRemote {
    func load(for request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        if request.path == LoginRequest.path {
            return Just(successResponse(token: "any", otpLength: 5))
                .setFailureType(to: Swift.Error.self)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return Just(apiError(messages: ["ENTER_CODE_SUBMIT_VALIDATION": "Incorrect code"]))
                .setFailureType(to: Swift.Error.self)
                .delay(for: 2, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

func successResponse(token: String, otpLength: Int, next: Int = 5) -> (Data, HTTPURLResponse) {
    let json = """
    {
        "confirmationToken": "\(token)",
        "nextAttemptAfter": \(next),
        "otpLength": \(otpLength)
    }
    """
    return apiSuccess(json: json)
}


func apiSuccess(json: String, code: Int = 200, url: URL? = nil) -> RemoteResponse {
    let response = HTTPURLResponse(url: url ?? URL(string: "https://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    let data = json.data(using: .utf8)!
    return (data, response)
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

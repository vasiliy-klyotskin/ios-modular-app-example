//
//  DemoRemoteRequestItem.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Foundation

final class DemoRemoteRequestItem {
    let name: String
    let path: String
    let method: String
    let responses: [DemoRemoteResponseItem]
    var selectedResponseIndex: Int
    var delay: Double
    
    var selectedResponse: DemoRemoteResponseItem {
        responses[selectedResponseIndex]
    }
    
    init(
        name: String,
        path: String,
        method: String,
        responses: [DemoRemoteResponseItem],
        initialResponseIndex: Int = 0,
        initialDelay: Double = 1
    ) {
        self.name = name
        self.path = path
        self.method = method
        self.responses = responses
        self.selectedResponseIndex = initialResponseIndex
        self.delay = initialDelay
    }
}

struct DemoRemoteResponseItem {
    struct DefaultError: Error {}
    
    let name: String
    let remoteResponse: Result<RemoteResponse, Error>
    
    static func success(name: String, _ response: RemoteResponse) -> Self {
        .init(name: name, remoteResponse: .success(response))
    }
    
    static func failure(name: String, _ error: Error = DefaultError()) -> Self {
        .init(name: name, remoteResponse: .failure(error))
    }
}

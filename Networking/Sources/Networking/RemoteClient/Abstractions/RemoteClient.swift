//
//  RemoteClient.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

public typealias RemoteClient = (RemoteRequest) -> AnyPublisher<RemoteResponse, Error>

public struct RemoteRequest {
    public let path: String
    public let method: String
    public let body: Body
    
    public init(path: String, method: String, body: Body) {
        self.path = path
        self.method = method
        self.body = body
    }
    
    public enum Body {
        case noBody
        case plain(Data)
        case encodable(Encodable)
    }
}

public typealias RemoteResponse = (Data, HTTPURLResponse)

//
//  RemoteClient.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

typealias RemoteClient = (RemoteRequest) -> AnyPublisher<RemoteResponse, Error>

struct RemoteRequest {
    let path: String
    let method: String
    let body: Body
    
    enum Body {
        case noBody
        case plain(Data)
        case encodable(Encodable)
    }
}

typealias RemoteResponse = (Data, HTTPURLResponse)

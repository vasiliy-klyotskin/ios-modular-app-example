//
//  RemoteClient.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

typealias RemoteClient = (RemoteRequest) -> AnyPublisher<RemoteResponse, Error>

struct RemoteRequest: Equatable {
    let path: String
    let method: String
    let body: Data?
}

typealias RemoteResponse = (Data, HTTPURLResponse)

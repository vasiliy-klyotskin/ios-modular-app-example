//
//  RemoteSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine
import Foundation
import Networking

public final class RemoteSpy {
    private var tasks = [PassthroughSubject<RemoteResponse, Error>]()
    public var requests = [RemoteRequest]()
    
    public init() {}
    
    public func load(request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        requests.append(request)
        let task = PassthroughSubject<(Data, HTTPURLResponse), Error>()
        tasks.append(task)
        return task.eraseToAnyPublisher()
    }
    
    public func finishWithError(index: Int) {
        tasks[index].send(completion: .failure(NSError(domain: "", code: 1)))
    }
    
    public func finishWith(response: RemoteResponse, index: Int) {
        tasks[index].send(response)
        tasks[index].send(completion: .finished)
    }
}

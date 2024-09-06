//
//  RemoteSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine
import Foundation
@testable import JustChat

final class RemoteSpy {
    var tasks = [PassthroughSubject<RemoteResponse, Error>]()
    var requests = [RemoteRequest]()
    
    func load(request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        requests.append(request)
        let task = PassthroughSubject<(Data, HTTPURLResponse), Error>()
        tasks.append(task)
        return task.eraseToAnyPublisher()
    }
    
    func finishWithError(index: Int) {
        tasks[index].send(completion: .failure(NSError(domain: "", code: 1)))
    }
    
    func finishWith(response: (Data, HTTPURLResponse), index: Int) {
        tasks[index].send(response)
        tasks[index].send(completion: .finished)
    }
}

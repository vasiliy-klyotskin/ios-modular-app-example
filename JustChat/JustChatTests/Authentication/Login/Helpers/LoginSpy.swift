//
//  LoginSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Foundation
import Combine

final class LoginSpy {
    var isLoadingUpdates: [Bool] = []
    var tasks = [PassthroughSubject<(Data, HTTPURLResponse), Error>]()
    var requests = [URLRequest]()
    var cancellables = [AnyCancellable]()
    
    typealias Sut = LoginTests.Sut
    
    func startSpying(sut: Sut) {
        sut.$isLoading.sink { [weak self] value in
            self?.isLoadingUpdates.append(value)
        }.store(in: &cancellables)
    }
    
    func remote(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        requests.append(request)
        let task = PassthroughSubject<(Data, HTTPURLResponse), Error>()
        tasks.append(task)
        return task.eraseToAnyPublisher()
    }
    
    func finishRemoteRequestWithError(index: Int) {
        tasks[index].send(completion: .failure(NSError(domain: "", code: 1)))
    }
    
    func finishRemoteRequestWith(response: (Data, HTTPURLResponse), index: Int) {
        tasks[index].send(response)
        tasks[index].send(completion: .finished)
    }
}

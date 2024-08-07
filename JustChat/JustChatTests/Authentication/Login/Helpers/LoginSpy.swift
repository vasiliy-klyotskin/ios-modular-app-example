//
//  LoginSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Foundation
import Combine

final class LoginSpy {
    var isLoading: Bool = false
    var inputError: String?
    
    var tasks = [PassthroughSubject<(Data, HTTPURLResponse), Error>]()
    var requests = [URLRequest]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: LoginTests.Sut) {
        sut.submitVm.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
        sut.inputVm.$error.bind(\.inputError, to: self, storeIn: &cancellables)
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

extension Published.Publisher {
    func bind<Root>(
        _ keyPath: ReferenceWritableKeyPath<Root, Value>,
        to target: Root,
        storeIn cancellables: inout Set<AnyCancellable>
    ) where Root: AnyObject {
        self
            .sink { [weak target] value in
                target?[keyPath: keyPath] = value
            }
            .store(in: &cancellables)
    }
}

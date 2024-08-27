//
//  EnterCodeSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Foundation
import Combine
@testable import JustChat

final class EnterCodeFeatureSpy {
//    var isLoading: Bool = false
//    var loginError: String?
//    var generalError: String?
    var successes = [EnterCodeModel]()
//    var regiterCalls = 0
//    var googleAuthCalls = 0
//    
    var tasks = [PassthroughSubject<RemoteResponse, Error>]()
    var requests = [RemoteRequest]()

    
    private var cancellables = Set<AnyCancellable>()
    
    func keepSuccess(model: EnterCodeModel) {
        successes.append(model)
    }
    
    func startSpying(sut: EnterCodeTests.Sut) {
//        sut.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
//        sut.toast.$message.bind(\.generalError, to: self, storeIn: &cancellables)
//        sut.input.$error.bind(\.loginError, to: self, storeIn: &cancellables)
    }
    
    func remote(request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
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

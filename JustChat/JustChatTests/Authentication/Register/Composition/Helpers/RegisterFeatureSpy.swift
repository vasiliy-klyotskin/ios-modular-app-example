//
//  RegisterFeatureSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
import Combine
@testable import JustChat

final class RegisterFeatureSpy {
    var isLoading: Bool = false
    var emailError: String?
    var usernameError: String?
    var generalError: String?
    var successes = [RegisterModel]()
    
    var tasks = [PassthroughSubject<RemoteResponse, Error>]()
    var requests = [RemoteRequest]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: RegisterFeatureTests.Sut) {
        sut.registerVm.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
        sut.toastVm.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.usernameInputVm.$error.bind(\.usernameError, to: self, storeIn: &cancellables)
        sut.emailInputVm.$error.bind(\.emailError, to: self, storeIn: &cancellables)
    }
    
    func remote(request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        requests.append(request)
        let task = PassthroughSubject<(Data, HTTPURLResponse), Error>()
        tasks.append(task)
        return task.eraseToAnyPublisher()
    }
    
    func keepRegisterModel(_ model: RegisterModel) {
        successes.append(model)
    }
    
    func finishRemoteRequestWithError(index: Int) {
        tasks[index].send(completion: .failure(NSError(domain: "", code: 1)))
    }
    
    func finishRemoteRequestWith(response: (Data, HTTPURLResponse), index: Int) {
        tasks[index].send(response)
        tasks[index].send(completion: .finished)
    }
}

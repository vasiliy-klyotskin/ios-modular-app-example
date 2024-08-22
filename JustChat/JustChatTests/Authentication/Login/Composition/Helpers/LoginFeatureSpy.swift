//
//  LoginSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Foundation
import Combine
@testable import JustChat

final class LoginFeatureSpy {
    var isLoading: Bool = false
    var loginError: String?
    var generalError: String?
    var successes = [LoginModel]()
    var regiterCalls = 0
    var googleAuthCalls = 0
    
    var tasks = [PassthroughSubject<RemoteResponse, Error>]()
    var requests = [RemoteRequest]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func startSpying(sut: LoginFeatureTests.Sut) {
        sut.submitVm.$isLoading.bind(\.isLoading, to: self, storeIn: &cancellables)
        sut.toastVm.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.inputVm.$error.bind(\.loginError, to: self, storeIn: &cancellables)
    }
    
    func remote(request: RemoteRequest) -> AnyPublisher<RemoteResponse, Error> {
        requests.append(request)
        let task = PassthroughSubject<(Data, HTTPURLResponse), Error>()
        tasks.append(task)
        return task.eraseToAnyPublisher()
    }
    
    func keepLoginModel(_ model: LoginModel) {
        successes.append(model)
    }
    
    func finishRemoteRequestWithError(index: Int) {
        tasks[index].send(completion: .failure(NSError(domain: "", code: 1)))
    }
    
    func finishRemoteRequestWith(response: (Data, HTTPURLResponse), index: Int) {
        tasks[index].send(response)
        tasks[index].send(completion: .finished)
    }
    
    func incrementRegister() {
        regiterCalls += 1
    }
    
    func incrementGoogleAuth() {
        googleAuthCalls += 1
    }
}

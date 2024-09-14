//
//  Combine+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Combine
import Foundation

extension Publisher {
    func flatMapResult<T>(_ map: @escaping (Output) -> Result<T, Failure>) -> AnyPublisher<T, Failure> {
        flatMap { map($0).publisher }
        .eraseToAnyPublisher()
    }
    
    func onLoadingStart(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { _ in action() })
    }
    
    func onLoadingFinish(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in action() }, receiveCompletion: {
            if case .failure = $0 {
                action()
            }
        })
    }
    
    func onLoadingSuccess(_ action: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { output in action(output) })
    }
    
    func onLoadingSuccess(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in action() })
    }
    
    func onLoadingFailure(_ action: @escaping (Failure) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                action(error)
            }
        })
    }
    
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

func start<Output, Failure: Error, Request>(_ publisher: @escaping (Request) -> AnyPublisher<Output, Failure>) -> (Request) -> Void {
    var cancellables = Set<AnyCancellable>()
    return { a in publisher(a).sink().store(in: &cancellables) }
}

func cancellingStart<Output, Failure: Error, Request>(_ publisher: @escaping (Request) -> AnyPublisher<Output, Failure>) -> (Request) -> Void {
    var cancellables = Set<AnyCancellable>()
    return { a in
        cancellables.removeAll()
        publisher(a).sink().store(in: &cancellables)
    }
}

//
//  Combine+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Combine
import Foundation

extension Publisher {
    public func flatMapResult<T>(_ map: @escaping (Output) -> Result<T, Failure>) -> AnyPublisher<T, Failure> {
        flatMap { map($0).publisher }
        .eraseToAnyPublisher()
    }
    
    public func onLoadingStart(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { _ in action() })
    }
    
    public func onLoadingFinish(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in action() }, receiveCompletion: {
            if case .failure = $0 {
                action()
            }
        })
    }
    
    public func onLoadingSuccess(_ action: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { output in action(output) })
    }
    
    public func onLoadingSuccess(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in action() })
    }
    
    public func onLoadingFailure(_ action: @escaping (Failure) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                action(error)
            }
        })
    }
    
    public func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

public func start<Output, Failure: Error, Request>(_ publisher: @escaping (Request) -> AnyPublisher<Output, Failure>) -> (Request) -> Void {
    var cancellables = Set<AnyCancellable>()
    return { a in publisher(a).sink().store(in: &cancellables) }
}

public func cancellingStart<Output, Failure: Error, Request>(_ publisher: @escaping (Request) -> AnyPublisher<Output, Failure>) -> (Request) -> Void {
    var cancellables = Set<AnyCancellable>()
    return { a in
        cancellables.removeAll()
        publisher(a).sink().store(in: &cancellables)
    }
}

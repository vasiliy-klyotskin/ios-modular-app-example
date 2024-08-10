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
        flatMap { output in
            map(output)
                .publisher
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func onSubscription(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { _ in action() })
    }
    
    func onCompletion(_ action: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { _ in action() })
    }
    
    func onOutput(_ action: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { output in action(output) })
    }
    
    func onFailure(_ action: @escaping (Failure) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                action(error)
            }
        })
    }
    
    func fallback<F>(to fallbackPublisher: @escaping @autoclosure () -> AnyPublisher<Output, F>) -> AnyPublisher<Output, F> {
        self.catch { _ in
            fallbackPublisher()
        }.eraseToAnyPublisher()
    }
    
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

func liftToPublisher<T>(_ function: @escaping () -> T?) -> AnyPublisher<T, Error> {
    Deferred {
        Future { promise in
            if let result = function() {
                promise(.success(result))
            } else {
                promise(.failure(NSError(domain: "any", code: -1)))
            }
        }
    }
    .eraseToAnyPublisher()
}

func start<Output, Failure: Error, Request>(_ publisher: @escaping (Request) -> AnyPublisher<Output, Failure>) -> (Request) -> Void {
    var cancellable = Set<AnyCancellable>()
    return { a in publisher(a).sink().store(in: &cancellable) }
}

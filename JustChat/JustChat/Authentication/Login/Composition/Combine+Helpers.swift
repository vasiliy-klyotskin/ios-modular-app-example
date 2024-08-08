//
//  Combine+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Combine

extension Publisher {
    func flatMapResult<T>(_ map: @escaping (Output) -> Result<T, Failure>) -> AnyPublisher<T, Failure> {
        flatMap { output -> AnyPublisher<T, Failure> in
            switch map(output) {
            case .success(let value):
                return Just(value)
                    .setFailureType(to: Failure.self)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}

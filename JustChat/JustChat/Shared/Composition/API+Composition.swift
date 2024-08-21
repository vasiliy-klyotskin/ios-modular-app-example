//
//  API+Composition.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Combine

extension Publisher where Output == RemoteResponse, Failure == Error {
    func mapResponseToDtoAndRemoteError<T: Decodable>() -> AnyPublisher<T, RemoteError> {
        mapError(RemoteMapper.mapError <~ RemoteStrings.values)
        .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
    }
}

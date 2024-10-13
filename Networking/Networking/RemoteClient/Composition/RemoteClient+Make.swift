//
//  RemoteClient+Make.swift
//  Networking
//
//  Created by Василий Клецкин on 9/29/24.
//

import Combine
import CompositionSupport

extension Publisher where Output == RemoteResponse, Failure == Error {
    public func mapResponseToDtoAndRemoteError<T: Decodable>() -> AnyPublisher<T, RemoteError> {
        mapError(RemoteMapper.mapError <~ RemoteStrings.values)
        .flatMapResult(RemoteMapper.mapSuccess <~ RemoteStrings.values)
    }
}

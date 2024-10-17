//
//  API+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
import Networking

extension RemoteRequest {
    public func dto<T: Encodable>() -> T? {
        if case let .encodable(encodable) = body, let dto = encodable as? T {
            return dto
        } else {
            return nil
        }
    }
}

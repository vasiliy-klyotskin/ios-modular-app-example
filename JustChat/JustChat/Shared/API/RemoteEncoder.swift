//
//  RemoteEncoder.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/19/24.
//

import Foundation

typealias RemoteEncoder<T: Encodable> = (T) -> Data?

func encodeDto<T: Encodable>(_ dto: T) -> Data? {
    try? JSONEncoder().encode(dto)
}

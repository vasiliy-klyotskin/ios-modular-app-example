//
//  RemoteClient.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

public typealias RemoteClient = (URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>

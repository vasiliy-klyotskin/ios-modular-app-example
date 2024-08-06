//
//  LoginCoreAbstractions.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import Combine

typealias LoginSubmitter = (LoginRequest) -> AnyPublisher<LoginModel, LoginError>

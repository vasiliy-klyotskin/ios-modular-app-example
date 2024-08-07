//
//  LoginCoreModels.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

typealias LoginRequest = String
typealias LoginModel = String

enum LoginError: Error {
    case input(String)
    case general(String)
}

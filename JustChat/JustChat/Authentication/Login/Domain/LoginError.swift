//
//  LoginError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

public enum LoginError: Error, Equatable {
    case input(String)
    case general(String)
}

//
//  RegisterError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

enum RegisterError: Error, Equatable {
    case validation([Validation])
    case general(String)
    
    enum Validation: Equatable {
        case email(String)
        case username(String)
    }
}

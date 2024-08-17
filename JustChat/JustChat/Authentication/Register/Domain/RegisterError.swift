//
//  RegisterError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

enum RegisterError {
    case validation([Validation])
    case general(String)
    
    enum Validation {
        case email(String)
        case username(String)
    }
}

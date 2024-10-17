//
//  EnterCodeModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

public struct EnterCodeSubmitModel: Equatable {
    let accessToken: String
    let refreshToken: String
}

public struct EnterCodeSubmitRequest {
    let code: String
    let confirmationToken: String
}

enum EnterCodeSubmitError: Error {
    case general(String)
    case validation(String)
}

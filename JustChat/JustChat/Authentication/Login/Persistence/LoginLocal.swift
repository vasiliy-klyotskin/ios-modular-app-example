//
//  LoginLocal.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

import Foundation

public struct LoginLocal {
    let login: String
    let confirmationToken: String
    let otpLength: Int
    let nextAttemptAfter: Int
    let timestamp: Date
}

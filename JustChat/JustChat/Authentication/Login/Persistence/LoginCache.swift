//
//  Untitled.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

import Foundation

public protocol LoginStorage {
    func set(local: LoginLocal, for login: String)
    func get(for login: String) -> LoginLocal?
}

public final class LoginCache {
    private let storage: LoginStorage
    private let currentTime: () -> Date
    
    public init(storage: LoginStorage = InMemoryLoginStorage(), currentTime: @escaping () -> Date) {
        self.storage = storage
        self.currentTime = currentTime
    }
    
    public func save(model: LoginModel) {
        let local = LoginLocal(
            login: model.login,
            confirmationToken: model.confirmationToken,
            otpLength: model.otpLength,
            nextAttemptAfter: model.nextAttemptAfter,
            timestamp: currentTime()
        )
        storage.set(local: local, for: model.login)
    }
    
    public func load(for login: LoginRequest) -> LoginModel? {
        guard let local = storage.get(for: login) else { return nil }
        let secondsSinceCached = Int(currentTime().timeIntervalSince(local.timestamp))
        guard secondsSinceCached < local.nextAttemptAfter else { return nil }
        let nextAttemptAfter = max(0, local.nextAttemptAfter - secondsSinceCached)
        return LoginModel(
            login: local.login,
            confirmationToken: local.confirmationToken,
            otpLength: local.otpLength,
            nextAttemptAfter: nextAttemptAfter
        )
    }
}

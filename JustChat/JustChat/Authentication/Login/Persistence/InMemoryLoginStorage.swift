//
//  LoginStorage.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

public final class InMemoryLoginStorage: LoginStorage {
    private var locals: [String: LoginLocal] = [:]
    
    public init() {}
    
    public func set(local: LoginLocal, for login: String) {
        locals[login] = local
    }
    
    public func get(for login: String) -> LoginLocal? {
        locals[login]
    }
}

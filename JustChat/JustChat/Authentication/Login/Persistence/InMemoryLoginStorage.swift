//
//  LoginStorage.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

final class InMemoryLoginStorage: LoginStorage {
    private var locals: [String: LoginLocal] = [:]
    
    func set(local: LoginLocal, for login: String) {
        locals[login] = local
    }
    
    func get(for login: String) -> LoginLocal? {
        locals[login]
    }
}

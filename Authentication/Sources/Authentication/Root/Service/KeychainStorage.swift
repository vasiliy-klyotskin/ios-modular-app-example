//
//  KeychainStorage.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Foundation

public final class KeychainStorage {
    let service: String
    
    public init(service: String) {
        self.service = service
    }
    
    func save(for id: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        SecItemAdd(query(id: id, data: data) as CFDictionary, nil)
    }
    
    func read(for id: String) -> String? {
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query(id: id, returningData: true) as CFDictionary, &dataTypeRef)
        if status == noErr, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func delete(for id: String) {
        SecItemDelete(query(id: id) as CFDictionary)
    }
    
    func flush() {
        SecItemDelete(query() as CFDictionary)
    }

    private func query(id: String? = nil, data: Data? = nil, returningData: Bool = false) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        if let id {
            query[kSecAttrAccount as String] = id
        }
        if let data {
            query[kSecValueData as String] = data
        }
        if returningData {
            query[kSecReturnData as String] = true
            query[kSecMatchLimit as String] = kSecMatchLimitOne
        }
        return query
    }
}

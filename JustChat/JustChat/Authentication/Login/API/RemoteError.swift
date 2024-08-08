//
//  RemoteError.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/8/24.
//

import Foundation

struct RemoteMessagesError {
    let messages: [String: String]
    let fallback: String
}

enum RemoteError: Error {
    case system(String)
    case messages(RemoteMessagesError)
}

struct RemoteStrings {
    let system: String
}

enum RemoteMapper {
    static func map<T: Decodable>(strings: RemoteStrings) -> (Data, HTTPURLResponse) -> Result<T, RemoteError> {{ data, response in
        if response.statusCode == 200 {
            do {
                let dto = try JSONDecoder().decode(T.self, from: data)
                return .success(dto)
            } catch {
                return .failure(.system(strings.system))
            }
        } else {
            do {
                let errorDto = try JSONDecoder().decode(RemoteMessagesErrorDTO.self, from: data)
                let errorModel = try errorDto.toModel()
                return .failure(.messages(errorModel))
            } catch {
                return .failure(.system(strings.system))
            }
        }
    }}
    
    static func map(strings: RemoteStrings) -> (Error) -> RemoteError {{ error in
        .system(strings.system)
    }}
}

struct RemoteMessagesErrorDTO: Decodable {
    let messages: [String: String]
    
    struct MessagesAreEmpty: Error {}
    
    func toModel() throws -> RemoteMessagesError {
        if let first = messages.first {
            return .init(messages: messages, fallback: first.value)
        } else {
            throw MessagesAreEmpty()
        }
    }
}

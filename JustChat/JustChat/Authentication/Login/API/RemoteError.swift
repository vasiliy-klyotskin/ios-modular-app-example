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
    static func mapSuccess<T: Decodable>(strings: RemoteStrings, success: (Data, HTTPURLResponse)) -> Result<T, RemoteError> {
        let (data, response) = success
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
    }
    
    static func mapError(strings: RemoteStrings, error: Error) -> RemoteError {
        .system(strings.system)
    }
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

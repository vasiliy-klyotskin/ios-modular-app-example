//
//  RegisterAPITests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import Testing
@testable import JustChat

@Suite
struct RegisterAPITests {
    @Test func testErrorMappingWithSystemMessage() {
        let remoteError = RemoteError.system("sys message")
        
        let result = RegisterError.fromRemoteError(remoteError)
        
        #expect(result == .general("sys message"))
    }
    
    @Test func testErrorMappingWithAllKeys() {
        let messages = RemoteMessagesError.init(
            messages: [
                RegisterError.emailKey: "email message",
                RegisterError.usernameKey: "username message",
                RegisterError.generalKey: "general message"
            ], fallback: "any")
        let remoteError = RemoteError.messages(messages)
        
        let result = RegisterError.fromRemoteError(remoteError)
        
        #expect(result == .validation([.email("email message"), .username("username message")]))
    }
    
    @Test func testErrorMappingWithGeneralKey() {
        let messages = RemoteMessagesError.init(messages: [ RegisterError.generalKey: "general message"], fallback: "any")
        let remoteError = RemoteError.messages(messages)
        
        let result = RegisterError.fromRemoteError(remoteError)
        
        #expect(result == .general("general message"))
    }

    @Test func testErrorMappingWhenThereIsNoKeys() {
        let messages = RemoteMessagesError.init(messages: [:], fallback: "fallback message")
        let remoteError = RemoteError.messages(messages)
        
        let result = RegisterError.fromRemoteError(remoteError)
        
        #expect(result == .general("fallback message"))
    }
}

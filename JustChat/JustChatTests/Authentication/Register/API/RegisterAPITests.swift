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
    @Test func testModelMapping() {
        let dto = RegisterResponseDTO(confirmationToken: "token", otpLength: 5, nextAttemptAfter: 20)
        let email = "some email"
        
        let result = RegisterModel.fromEmailAndDto(email: email, dto: dto)
        
        #expect(result == .init(email: "some email", confirmationToken: "token", otpLength: 5, nextAttemptAfter: 20))
    }
    
//    @Test func testSystemErrorMapping() {
//        let remoteError = RemoteError.system("sys message")
//        
//        let result = LoginError.fromRemoteError(remoteError)
//        
//        #expect(result == .general("sys message"))
//    }
//    
//    @Test func testInputErrorMappingWhenThereIsInputKey() {
//        let messages = RemoteMessagesError.init(messages: [LoginError.inputKey: "input message"], fallback: "any")
//        let remoteError = RemoteError.messages(messages)
//        
//        let result = LoginError.fromRemoteError(remoteError)
//        
//        #expect(result == .input("input message"))
//    }
//    
//    @Test func testInputErrorMappingWhenThereIsNoInputKey() {
//        let messages = RemoteMessagesError.init(messages: [:], fallback: "fallback message")
//        let remoteError = RemoteError.messages(messages)
//        
//        let result = LoginError.fromRemoteError(remoteError)
//        
//        #expect(result == .general("fallback message"))
//    }
}

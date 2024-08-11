//
//  LoginAPITests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
@testable import JustChat

@Suite
struct LoginAPITests {
    @Test func testModelMapping() {
        let dto = LoginResponseDTO(confirmationToken: "token", otpLength: 5, nextAttemptAfter: 20)
        let login = "some login"
        
        let result = LoginModel.fromLoginAndDto(login: login, dto: dto)
        
        #expect(result == .init(login: "some login", confirmationToken: "token", otpLength: 5, nextAttemptAfter: 20))
    }
    
    @Test func testSystemErrorMapping() {
        let remoteError = RemoteError.system("sys message")
        
        let result = LoginError.fromRemoteError(remoteError)
        
        #expect(result == .general("sys message"))
    }
    
    @Test func testInputErrorMappingWhenThereIsInputKey() {
        let messages = RemoteMessagesError.init(messages: [LoginError.inputKey: "input message"], fallback: "any")
        let remoteError = RemoteError.messages(messages)
        
        let result = LoginError.fromRemoteError(remoteError)
        
        #expect(result == .input("input message"))
    }
    
    @Test func testInputErrorMappingWhenThereIsNoInputKey() {
        let messages = RemoteMessagesError.init(messages: [:], fallback: "fallback message")
        let remoteError = RemoteError.messages(messages)
        
        let result = LoginError.fromRemoteError(remoteError)
        
        #expect(result == .general("fallback message"))
    }
}

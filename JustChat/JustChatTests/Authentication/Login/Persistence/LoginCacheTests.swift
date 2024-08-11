//
//  LoginCacheTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import Foundation
import JustChat

@Suite
final class LoginCacheTests {
    @Test func sutShouldReturnNothingWhenThereIsNothingInStorage() {
        let (sut, _) = makeSut()
        
        let result = sut.load(for: "some key")
        
        #expect(result == nil)
    }
    
    @Test func sutShouldReturnNothingForDifferentKey() {
        let (sut, _) = makeSut()
        sut.save(model: .init(login: "some login", confirmationToken: "any", otpLength: 4, nextAttemptAfter: 10))
        
        let result = sut.load(for: "another login")
        
        #expect(result == nil)
    }
    
    @Test func sutShouldReturnModelForPreviouslyCachedModel() {
        let (sut, _) = makeSut()
        sut.save(model: .init(login: "login", confirmationToken: "token", otpLength: 4, nextAttemptAfter: 10))
        
        let result = sut.load(for: "login")
        
        #expect(result == .init(login: "login", confirmationToken: "token", otpLength: 4, nextAttemptAfter: 10))
    }
    
    typealias Sut = LoginCache
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, LoginCacheSpy) {
        let spy = LoginCacheSpy()
        let storage = InMemoryLoginStorage()
        let sut = Sut(storage: storage, currentTime: spy.getCurrentTime)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(storage)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }

    deinit {
        leakChecker.check()
    }
}

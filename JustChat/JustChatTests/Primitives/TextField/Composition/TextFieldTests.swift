//
//  TextFieldTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import JustChat

@Suite
final class TextFieldTests {
    @Test func sutNotifiesAboutNewInput() async throws {
        let (sut, spy) = makeSut()
        #expect(spy.onInputCalls.isEmpty)
        
        sut.changeInput("a")
        #expect(spy.onInputCalls == ["a"])
        
        sut.changeInput("ab")
        #expect(spy.onInputCalls == ["a", "ab"])
    }
    
    typealias Sut = TextFieldViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, TextFieldSpy) {
        let spy = TextFieldSpy()
        let sut = Sut.make(error: spy.$externalError, onInput: spy.appendInputCall)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
    
    deinit {
        leakChecker.check()
    }
}

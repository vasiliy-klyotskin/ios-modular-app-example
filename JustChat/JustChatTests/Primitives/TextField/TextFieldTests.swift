//
//  TextFieldTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
@testable import JustChat

@Suite
final class TextFieldTests {
    @Test
    func sutPerformsInputFlow() {
        let (sut, spy) = makeSut()
        
        // MARK: When input flow begins
        #expect(spy.onInputCalls.isEmpty, "There shouldn't be any message.")
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isTitleShown == false, "The title should be hidden.")
        
        // MARK: When input changes to "a"
        sut.changeInput("a")
        #expect(spy.onInputCalls == ["a"], "Expected message with input 'a'.")
        #expect(spy.internalError == nil, "There shouldn't be an error after input 'a'.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isTitleShown == true, "The title should be visible.")
        
        // MARK: When input changes to "ab"
        sut.changeInput("ab")
        #expect(spy.onInputCalls == ["a", "ab"], "Expected messages with inputs 'a' and 'ab'.")
        #expect(spy.internalError == nil, "There shouldn't be an error'.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isTitleShown == true, "The title should remain visible.")
        
        // MARK: When external error occurs
        spy.externalError = "error"
        #expect(spy.onInputCalls == ["a", "ab"], "Expected no additional messages.")
        #expect(spy.internalError == "error", "Expected internal error to be set.")
        #expect(sut.isError == true, "There should be an error.")
        #expect(sut.isTitleShown == true, "The title should remain visible despite the error.")
        
        // MARK: When input is cleared
        sut.clear()
        #expect(spy.onInputCalls == ["a", "ab", ""], "Expected messages including the cleared input.")
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isTitleShown == false, "The title should be hidden.")
        
        // MARK: When input changes to "abc"
        sut.changeInput("abc")
        #expect(spy.onInputCalls == ["a", "ab", "", "abc"], "Expected messages with all inputs including 'abc'.")
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isTitleShown == true, "The title should be visible.")
    }
    
    typealias Sut = TextFieldViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, TextFieldSpy) {
        let spy = TextFieldSpy()
        let sut = Sut.make(error: spy.$externalError, onInput: spy.appendInputCall)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
}

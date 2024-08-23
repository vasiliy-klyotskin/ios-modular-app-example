//
//  TextFieldTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
@testable import JustChat

@Suite final class TextFieldTests {
    @Test func basicFlow() {
        let (sut, spy) = makeSut()
        
        // MARK: When input flow begins
        #expect(spy.error == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == false, "Clear button shouldn't be displayed")
        
        // MARK: When input changes to "a"
        sut.changeInput("a")
        #expect(spy.error == nil, "There shouldn't be an error after input 'a'.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
        
        // MARK: When input changes to "ab"
        sut.changeInput("ab")
        #expect(spy.error == nil, "There shouldn't be an error'.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
        
        // MARK: When external error occurs
        sut.updateError("error")
        #expect(spy.error == "error", "Expected internal error to be set.")
        #expect(sut.isError == true, "There should be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
        
        // MARK: When input is cleared
        sut.clear()
        #expect(spy.error == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == false, "Clear button shouldn't be displayed")
        
        // MARK: When input changes to "abc"
        sut.changeInput("abc")
        #expect(spy.error == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
        
        // MARK: When external error occurs
        sut.updateError("error")
        #expect(spy.error == "error", "Expected internal error to be set.")
        #expect(sut.isError == true, "There should be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
        
        // MARK: When external error is nil
        sut.updateError(nil)
        #expect(spy.error == nil, "There shouldn't be an error.")
        #expect(sut.isError == false, "There shouldn't be an error.")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed")
    }
    
    typealias Sut = TextFieldViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, TextFieldSpy) {
        let spy = TextFieldSpy()
        let sut = TextFieldViewModel()
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

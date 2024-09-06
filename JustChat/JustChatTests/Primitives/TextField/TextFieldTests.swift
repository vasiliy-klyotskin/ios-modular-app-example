//
//  TextFieldTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
@testable import JustChat

@Suite final class TextFieldTests {
    @Test func error() {
        let (sut, spy) = makeSut()
        
        #expect(spy.error == nil, "There shouldn't be an error initially.")
        #expect(sut.isError == false, "There shouldn't be an error initially.")
        
        sut.updateError("error")
        #expect(spy.error == "error", "There should be an error after error set.")
        #expect(sut.isError == true, "There should be an error after error set.")
        
        sut.simulateChangingInput("any")
        #expect(spy.error == nil, "There shouldn't be an error after the user changes input.")
        #expect(sut.isError == false, "There shouldn't be an error after the user changes input.")
        
        sut.updateError("error")
        sut.clear()
        #expect(spy.error == nil, "There shouldn't be an error after the user clears input.")
        #expect(sut.isError == false, "There shouldn't be an error after the user clears input.")
        
        sut.updateError("error")
        sut.updateError(nil)
        #expect(spy.error == nil, "There shouldn't be an error after the external error is nil.")
        #expect(sut.isError == false, "There shouldn't be an error after the external error is nil.")
    }
    
    @Test func clearButtonIsShown() {
        let (sut, _) = makeSut()
        
        #expect(sut.isClearButtonShown == false, "Clear button shouldn't be displayed initially.")
        
        sut.simulateChangingInput("a")
        #expect(sut.isClearButtonShown == true, "Clear button should be displayed after the user enters something.")
        
        sut.clear()
        #expect(sut.isClearButtonShown == false, "Clear button shouldn't be displayed after the user clears the input.")
    }
    
    // MARK: - Helpers
    
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

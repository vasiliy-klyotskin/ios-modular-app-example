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
    @Test func sutNotifiesAboutNewInput() {
        let (sut, spy) = makeSut()
        #expect(spy.onInputCalls.isEmpty)
        
        sut.changeInput("a")
        #expect(spy.onInputCalls == ["a"])
        
        sut.changeInput("ab")
        #expect(spy.onInputCalls == ["a", "ab"])
    }
    
    @Test func sutPresentsInternalError() {
        let (sut, spy) = makeSut()
        _ = sut
        #expect(spy.internalError == nil)
        
        spy.externalError = "error"
        #expect(spy.internalError == "error")
        
        spy.externalError = nil
        #expect(spy.internalError == nil)
    }
    
    @Test func sutHidesErrorOnInputChange() {
        let (sut, spy) = makeSut()
        spy.externalError = "error"
        sut.changeInput("a")
        
        #expect(spy.internalError == nil)
    }
    
    @Test func sutPresentsTitle() {
        let (sut, _) = makeSut()
        #expect(sut.isTitleShown == false)
        
        sut.changeInput("a")
        #expect(sut.isTitleShown == true)
        
        sut.changeInput("")
        #expect(sut.isTitleShown == false)
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
    
    deinit {
        leakChecker.check()
    }
}

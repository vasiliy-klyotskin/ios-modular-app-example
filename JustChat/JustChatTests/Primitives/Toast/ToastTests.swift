//
//  ToastTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class ToastTests {
    @Test func messagePresentation() {
        let (sut, spy) = makeSut()
        
        #expect(spy.message == nil, "There shouldn't be an error initially.")
        #expect(sut.toastIsPresented == false)
        
        sut.updateMessage("some message")
        #expect(spy.message == "some message", "There should be an error when message appears")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 4)
        #expect(spy.message == "some message", "There should be an error when presentation time is almost over")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == nil, "There shouldn't be an error shen presentation time is over.")
        #expect(sut.toastIsPresented == false)
        
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error shen another message appears")
        #expect(sut.toastIsPresented == true)
        
        sut.simulateTappingToast()
        #expect(spy.message == nil, "There shouldn't be an error when toast has been tapped.")
        #expect(sut.toastIsPresented == false)
        
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error when another message appears")
        #expect(sut.toastIsPresented == true)
        
        sut.updateMessage(nil)
        #expect(spy.message == nil, "There shouldn't be an error when message is updated to nil.")
        #expect(sut.toastIsPresented == false)
    }
    
    @Test func doesNotHideNewErrorAfterDelayWhenPreviousWasHiddenByTap() {
        let (sut, spy) = makeSut()
        
        #expect(spy.message == nil, "There shouldn't be an error when toast presentation flow begins.")
        #expect(sut.toastIsPresented == false)
        
        sut.updateMessage("some message")
        #expect(spy.message == "some message", "There should be an error when message appears.")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 2)
        sut.simulateTappingToast()
        #expect(spy.message == nil, "There shouldn't be an error when toast has been tapped after some time.")
        #expect(sut.toastIsPresented == false)
        
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error when another message appears.")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 3)
        #expect(spy.message == "another message", "There should be an error when presentation time is over for previous error.")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == "another message", "There should be an error when presentation time is not over for current error.")
        #expect(sut.toastIsPresented == true)
        
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == nil, "There shouldn't be an error when presentation time is over for current error.")
        #expect(sut.toastIsPresented == false)
    }
    
    @Test func sutDeallocatesAfterErrorReceive() {
        let (sut, _) = makeSut()
        sut.updateMessage("some message")
    }
    
    // MARK: - Helpers

    typealias Sut = ToastViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, ToastSpy) {
        let scheduler = DispatchQueue.test
        let spy = ToastSpy(uiScheduler: scheduler)
        let sut = Sut.make(uiScheduler: scheduler.eraseToAnyScheduler())
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

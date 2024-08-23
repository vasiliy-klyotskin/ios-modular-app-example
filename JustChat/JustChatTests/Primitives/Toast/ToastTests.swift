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
    @Test func basicFlow() {
        let (sut, spy) = makeSut()
        
        // MARK: When toast presentation flow begins
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When message appears
        sut.updateMessage("some message")
        #expect(spy.message == "some message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is almost over
        spy.simulateTimePassed(seconds: 4)
        #expect(spy.message == "some message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When another message appears
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When toast has been tapped
        sut.tapToast()
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When another message appears
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When message is updated to nil
        sut.updateMessage(nil)
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
    }
    
    @Test func sutDoesNotHideNewErrorAfterDelayWhenPreviousWasHiddenByTap() {
        let (sut, spy) = makeSut()
        
        // MARK: When toast presentation flow begins
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When message appears
        sut.updateMessage("some message")
        #expect(spy.message == "some message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When toast has been tapped after some time
        spy.simulateTimePassed(seconds: 2)
        sut.tapToast()
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When another message appears
        sut.updateMessage("another message")
        #expect(spy.message == "another message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over for previous error
        spy.simulateTimePassed(seconds: 3)
        #expect(spy.message == "another message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is not over for current error
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == "another message", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over for current error
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.message == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
    }
    
    @Test func sutDeallocatesAfterErrorReceive() {
        let (sut, _) = makeSut()
        sut.updateMessage("some message")
    }

    typealias Sut = ToastViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, ToastSpy) {
        let scheduler = DispatchQueue.test
        let spy = ToastSpy(scheduler: scheduler)
        let sut = Sut.make(scheduler: scheduler.eraseToAnyScheduler())
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        return (sut, spy)
    }
}

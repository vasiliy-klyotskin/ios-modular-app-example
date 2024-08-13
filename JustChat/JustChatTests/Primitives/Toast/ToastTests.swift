//
//  ToastTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite
final class ToastTests {
    @Test
    func sutPerformsBasicToastPresentationFlow() {
        let (sut, spy) = makeSut()
        
        // MARK: When toast presentation flow begins
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When external error occurs
        spy.externalError = "some error"
        #expect(spy.internalError == "some error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is almost over
        spy.simulateTimePassed(seconds: 4)
        #expect(spy.internalError == "some error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When another external error occurs
        spy.externalError = "another error"
        #expect(spy.internalError == "another error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When toast has been tapped
        sut.tapToast()
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
    }
    
    @Test
    func sutDoesNotHideNewErrorWhenPreviousWasHiddenByTap() {
        let (sut, spy) = makeSut()
        
        // MARK: When toast presentation flow begins
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When external error occurs
        spy.externalError = "some error"
        #expect(spy.internalError == "some error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When toast has been tapped after some time
        spy.simulateTimePassed(seconds: 2)
        sut.tapToast()
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
        
        // MARK: When another external error occurs
        spy.externalError = "another error"
        #expect(spy.internalError == "another error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over for previous error
        spy.simulateTimePassed(seconds: 3)
        #expect(spy.internalError == "another error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is not over for current error
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.internalError == "another error", "There should be an error")
        #expect(sut.toastIsPresented == true, "Toast should be presented.")
        
        // MARK: When presentation time is over for current error
        spy.simulateTimePassed(seconds: 1)
        #expect(spy.internalError == nil, "There shouldn't be an error.")
        #expect(sut.toastIsPresented == false, "Toast should be hidden.")
    }
    
    @Test
    func sutDeallocatesRitghtAfterErrorReceive() {
        let (_, spy) = makeSut()
        spy.externalError = "some error"
    }

    typealias Sut = ToastViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(_ loc: SourceLocation = #_sourceLocation) -> (Sut, ToastSpy) {
        let scheduler = DispatchQueue.test
        let spy = ToastSpy(scheduler: scheduler)
        let sut = Sut.make(error: spy.$externalError, scheduler: scheduler.eraseToAnyScheduler())
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, sourceLocation: loc)
        leakChecker.addForChecking(spy, sourceLocation: loc)
        return (sut, spy)
    }
}

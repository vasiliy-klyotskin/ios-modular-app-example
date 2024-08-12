//
//  ToastTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing
import Foundation
import JustChat

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
        spy.simulateTimePassed(seconds: 10)
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

    typealias Sut = ToastViewModel
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut() -> (Sut, ToastSpy) {
        let scheduler = DispatchQueue.test
        let spy = ToastSpy(scheduler: scheduler)
        let sut = Sut.make(error: spy.$externalError, scheduler: scheduler.eraseToAnyScheduler())
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut)
        leakChecker.addForChecking(spy)
        return (sut, spy)
    }
    
    deinit {
        leakChecker.check()
    }
}

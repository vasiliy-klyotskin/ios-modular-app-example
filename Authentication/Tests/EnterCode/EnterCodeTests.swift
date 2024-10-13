//
//  EnterCodeTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Testing
import Foundation
import Networking
import CompositionTestingTools
@testable import Authentication

@Suite final class EnterCodeTests {
    // MARK: - Resending
    
    @Test func resendingRequest() {
        let (sut, spy) = makeSut(token: "initial token", nextAttempt: 30)
        
        #expect(spy.remote.requests.isEmpty, "There should be no requests initially.")
        
        spy.timer.simulateTimePassed(seconds: 29)
        sut.simulateUserTapsResend()
        #expect(spy.remote.requests.isEmpty, "There should be no requests before time is over.")
        
        spy.timer.simulateTimePassed(seconds: 1)
        sut.simulateUserTapsResend()
        expectResendRequestIsCorrect(spy.remote.requests[0], for: "initial token", "There should be a new request after time is over.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving error.")
        
        sut.simulateUserTapsResend()
        expectResendRequestIsCorrect(spy.remote.requests[1], for: "initial token", "There should be a new request after resending again.")
        
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "new token", otpLength: 3, next: 10), index: 1)
        #expect(spy.remote.requests.count == 2, "There should be no new requests after receiving success.")
        
        spy.timer.simulateTimePassed(seconds: 10)
        sut.simulateUserTapsResend()
        expectResendRequestIsCorrect(spy.remote.requests[2], for: "new token", "There should be a new request with new token after resending again.")
    }
    
    @Test func resendingLoadingIndicator() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submission loading indicator initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.isResendingLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user taps resend after delay.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after receiving error.")
        
        sut.simulateUserTapsResend()
        #expect(spy.isResendingLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user taps resend again.")
        
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 4, next: 30), index: 1)
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after success.")
    }
    
    @Test func contentIsDisabledDuringResending() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.isResendButtonDisabled == true, "Button should be dimmed initially.")
        #expect(spy.isCodeInputDimmed == false, "Input should not be dimmed.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.isResendButtonDisabled == false, "Button should not be dimmed after time is over.")
        #expect(spy.isCodeInputDimmed == false, "Input should not be dimmed.")
        
        sut.simulateUserTapsResend()
        #expect(spy.isResendButtonDisabled == true, "Button should be dimmed after the user initiates resending.")
        #expect(spy.isCodeInputDimmed == true, "Input should be dimmed.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isResendButtonDisabled == false, "Button should not be dimmed after error.")
        #expect(spy.isCodeInputDimmed == false, "Input should not be dimmed.")
        
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 4, next: 30), index: 1)
        #expect(spy.isResendButtonDisabled == true, "Button should be dimmed after success.")
        #expect(spy.isCodeInputDimmed == false, "Input should not be dimmed.")
    }
    
    @Test func resendingGeneralError() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.generalError == nil, "There should not be a general error initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.generalError == nil, "There should not be a general error after the user taps resend after delay.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a general error after request failure.")
        
        sut.simulateUserTapsResend()
        #expect(spy.generalError == nil, "There should not be a general error when the user taps resend after error.")
        
        spy.finishRemoteWith(response: SutData.resendGeneralError("some error message"), index: 1)
        #expect(spy.generalError == "some error message", "There should be a general error after receiving remote error.")
        
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 4), index: 2)
        #expect(spy.generalError == nil, "There should not be a general error after success.")
    }
    
    @Test func validationErrorDuringResending() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        #expect(spy.validationError == nil, "There should be no validation error initially.")
        
        sut.simulateUserEntersOtp("2345")
        spy.finishRemoteWith(response: SutData.submitValidationError("validation error"), index: 0)
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.validationError == nil, "There should be no validation error after the user resends otp.")
    }
    
    @Test func resendingTimeLeft() {
        let (sut, spy) = makeSut(nextAttempt: 0)
        
        #expect(spy.showRemainingTime == false, "Remaining time should not be displayed initially if next attempt time is zero.")
        
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 4, next: 150), index: 0)
        #expect(spy.showRemainingTime == true, "Remaining time should be displayed initially.")
        #expect(spy.timeRemainingUntilNextAttempt == "2:29", "Remaining time should be correct initially.")
        
        spy.timer.simulateTimePassed(seconds: 148)
        #expect(spy.showRemainingTime == true, "Remaining time should be displayed after some time have passed.")
        #expect(spy.timeRemainingUntilNextAttempt == "0:01", "Remaining time should be correct after some time have passed.")
        
        spy.timer.simulateTimePassed(seconds: 1)
        #expect(spy.showRemainingTime == true, "Remaining time should be displayed before last second has passed.")
        #expect(spy.timeRemainingUntilNextAttempt == "0:00", "Remaining time be equal zero before last second has passed.")
        
        spy.timer.simulateTimePassed(seconds: 1)
        #expect(spy.showRemainingTime == false, "Remaining time should be hidden after time is over.")
        
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 4, next: 25), index: 1)
        #expect(spy.showRemainingTime == true, "Remaining time should be displayed after resending.")
        #expect(spy.timeRemainingUntilNextAttempt == "0:24", "Remaining time should be correct after resending.")
    }
    
    @Test func codeInputValueDuringResending() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        #expect(sut.code() == "", "Code should be empty initially.")
        
        sut.simulateUserEntersOtp("435")
        #expect(sut.code() == "435", "Code should be set after the user enters it.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(sut.code() == "435", "Code should persist after the user taps resend.")
        
        sut.simulateUserEntersOtp("123")
        #expect(sut.code() == "435", "Code should not change when the user tries to change it after the request starts.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(sut.code() == "435", "Code should persist after receiving an error")
        
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 5), index: 1)
        #expect(sut.code() == "", "Code should be cleared after successful resending.")
    }
    
    // MARK: Submission
    
    @Test func submissionRequest() {
        let (sut, spy) = makeSut(token: "confirmation token", otpLength: 4, nextAttempt: 20)
        
        #expect(spy.remote.requests.isEmpty, "There should be no requests initially.")
        
        sut.simulateUserEntersOtp("452")
        #expect(spy.remote.requests.isEmpty, "There should be no requests before the user enters full code.")
        
        sut.simulateUserEntersOtp("4523")
        expectSubmitRequestIsCorrect(spy.remote.requests[0], code: "4523", token: "confirmation token", "There should be a request when the user enters full code")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving error.")
        
        spy.timer.simulateTimePassed(seconds: 20)
        sut.simulateUserTapsResend()
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "new token", otpLength: 4), index: 1)
        sut.simulateUserEntersOtp("5432")
        expectSubmitRequestIsCorrect(spy.remote.requests[2], code: "5432", token: "new token", "There should be a new request with new token when the user enters a full code after resending")
        
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 2)
        sut.simulateUserEntersOtp("5432")
        #expect(spy.remote.requests.count == 3, "There should be no new requests after submitting the same code after success (edge case).")
    }
    
    @Test func submissionLoadingIndicator() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.isSubmissionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator initially.")
        
        sut.simulateUserEntersOtp("4523")
        #expect(spy.isSubmissionLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user enters otp.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isSubmissionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after receiving error.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.isSubmissionLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user enters otp.")
        
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.isSubmissionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after success.")
    }
    
    @Test func submissionGeneralError() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.generalError == nil, "There should be no general error initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.generalError == nil, "There should be no general error after user submits otp.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a general error after request failure.")
        
        sut.simulateUserEntersOtp("4321")
        #expect(spy.generalError == nil, "There should be no general error when user submits new otp.")
        
        spy.finishRemoteWith(response: SutData.submitGeneralError("general error"), index: 1)
        #expect(spy.generalError == "general error", "There should be a general error after receiving remote error.")
        
        sut.simulateUserEntersOtp("4654")
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 2)
        #expect(spy.generalError == nil, "There should be no general error after success.")
    }
    
    @Test func submissionValidationError() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.validationError == nil, "There should be no validation error initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.validationError == nil, "There should be no validation error after the user submits otp.")
        
        spy.finishRemoteWith(response: SutData.submitValidationError("validation error"), index: 0)
        #expect(spy.validationError == "validation error", "There should be a validation error after receiving backend error.")
        
        sut.simulateUserEntersOtp("456")
        #expect(spy.validationError == nil, "There should be no validation error after the user changes otp.")
        
        sut.simulateUserEntersOtp("4567")
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.validationError == nil, "There should be no validation error after success.")
    }
    
    @Test func otpLength() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        #expect(spy.otpLength == 4, "Otp length should be set initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.otpLength == 4, "Otp length should not be changed after some time passed.")
        
        sut.simulateUserTapsResend()
        #expect(spy.otpLength == 4, "Otp length should not be changed after user resends otp.")
        
        spy.finishRemoteWith(response: SutData.successResendResponse(token: "any", otpLength: 5, next: 10), index: 0)
        #expect(spy.otpLength == 5, "Otp length should be changed after receiving new otp length.")
    }
    
    @Test func contentIsDisabledDuringSubmission() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.isResendButtonDisabled == true, "Resend button should be dimmed after submission starts.")
        #expect(spy.isCodeInputDimmed == false, "Code input should not be dimmed.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isResendButtonDisabled == true, "Resend button should be dimmed after error because time before resending is not over yet.")
        #expect(spy.isCodeInputDimmed == false, "Code input should be enabled after receiving an error.")
        
        sut.simulateUserEntersOtp("4567")
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.isResendButtonDisabled == true, "Resend button should be dimmed during request even if time is over.")
        #expect(spy.isCodeInputDimmed == false, "Code input should not be dimmed.")
        
        spy.finishRemoteWith(response: SutData.submitGeneralError("any"), index: 1)
        #expect(spy.isResendButtonDisabled == false, "Resend button should not be dimmed after error if time is over.")
        #expect(spy.isCodeInputDimmed == false, "Code input should not be dimmed.")
        
        sut.simulateUserEntersOtp("7890")
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 2)
        #expect(spy.isResendButtonDisabled == false, "Resend button should not be dimmed after success.")
        #expect(spy.isCodeInputDimmed == false, "Code input should not be dimmed.")
    }
    
    @Test func successMessage() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.successes.isEmpty, "There should not be success message initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.successes.isEmpty, "There should not be success message after user initiates submission.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.successes.isEmpty, "There should not be success message after error.")
        
        sut.simulateUserEntersOtp("1234")
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "access", refreshToken: "refresh"), index: 1)
        #expect(spy.successes[0] == SutData.successModel(access: "access", refresh: "refresh"), "There should be a message after success")
    }
    
    @Test func codeInputValueDuringSubmission() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        #expect(sut.code() == "", "Code should be empty initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(sut.code() == "1234", "Code should be set right after the user submits.")
        
        sut.simulateUserEntersOtp("123")
        #expect(sut.code() == "1234", "Code should not change when the user tries to change it after the request starts.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(sut.code() == "", "Code should be cleared after receiving an error.")
        
        sut.simulateUserEntersOtp("4321")
        spy.finishRemoteWith(response: SutData.successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(sut.code() == "4321", "Code should persist after receiving success.")
    }
    
    // MARK: - Helpers
    
    typealias Sut = EnterCodeFeature
    typealias SutData = EnterCodeData
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(
        token: String = "any token",
        otpLength: Int = 6,
        nextAttempt: Int = 45,
        _ loc: SourceLocation = #_sourceLocation
    ) -> (Sut, EnterCodeFeatureSpy) {
        let spy = EnterCodeFeatureSpy()
        let env = EnterCodeEnvironment(
            remoteClient: spy.remote.load,
            uiScheduler: spy.uiScheduler.eraseToAnyScheduler(),
            toast: .init(),
            makeTimer: spy.timer.make()
        )
        let events = EnterCodeEvents(onCorrectOtpEnter: spy.keepSuccess)
        let model = EnterCodeResendModel(confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttempt)
        let sut = EnterCodeFeature.make(env: env, events: events, model: model)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, spy.remote, sourceLocation: loc)
        sut.simulateViewAppeared()
        return (sut, spy)
    }
}

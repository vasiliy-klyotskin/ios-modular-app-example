//
//  EnterCodeTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Testing
import Foundation
@testable import JustChat

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
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving error.")
        
        sut.simulateUserTapsResend()
        expectResendRequestIsCorrect(spy.remote.requests[1], for: "initial token", "There should be a new request after resending again.")
        
        spy.remote.finishWith(response: successResendResponse(token: "new token", otpLength: 3, next: 10), index: 1)
        #expect(spy.remote.requests.count == 2, "There should be no new requests after receiving success.")
        
        spy.timer.simulateTimePassed(seconds: 10)
        sut.simulateUserTapsResend()
        expectResendRequestIsCorrect(spy.remote.requests[2], for: "new token", "There should be a new request with new token after resending again.")
    }
    
    @Test func resendingLoadingIndicator() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submittion loading indicator initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.isResendingLoadingIndicatorDisplayed == true, "There should be a submittion loading indicator after the user taps resend after delay.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submittion loading indicator after receiving error.")
        
        sut.simulateUserTapsResend()
        #expect(spy.isResendingLoadingIndicatorDisplayed == true, "There should be a submittion loading indicator after the user taps resend again.")
        
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4, next: 30), index: 1)
        #expect(spy.isResendingLoadingIndicatorDisplayed == false, "There should be no submittion loading indicator after success.")
    }
    
    @Test func resendingButtonIsDisabled() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.isResendButtonDisabled == true, "Button should be disabled initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.isResendButtonDisabled == false, "Button should not be disabled after time is over.")
        
        sut.simulateUserTapsResend()
        #expect(spy.isResendButtonDisabled == true, "Button should be disabled after the user initiates resending.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.isResendButtonDisabled == false, "Button should not be disabled after error.")
        
        sut.simulateUserTapsResend()
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4, next: 30), index: 1)
        #expect(spy.isResendButtonDisabled == true, "Button should be disabled after success.")
    }
    
    @Test func resendingGeneralError() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.generalError == nil, "There should not be a general error initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.generalError == nil, "There should not be a general error after the user taps resend after delay.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a general error after request failure.")
        
        sut.simulateUserTapsResend()
        #expect(spy.generalError == nil, "There should not be a general error when the user taps resend after error.")
        
        spy.remote.finishWith(response: resendGeneralError("some error message"), index: 1)
        #expect(spy.generalError == "some error message", "There should be a general error after receiving remote error.")
        
        sut.simulateUserTapsResend()
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4), index: 2)
        #expect(spy.generalError == nil, "There should not be a general error after success.")
    }
    
    @Test func resendingTimeLeft() {
        let (sut, spy) = makeSut(nextAttempt: 0)
        
        #expect(spy.showRemainingTime == false, "Remaining time should not be displayed initially if next attempt time is zero.")
        
        sut.simulateUserTapsResend()
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4, next: 150), index: 0)
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
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4, next: 25), index: 1)
        #expect(spy.showRemainingTime == true, "Remaining time should be displayed after resending.")
        #expect(spy.timeRemainingUntilNextAttempt == "0:24", "Remaining time should be correct after resending.")
    }
    
    @Test func codeInputIsDisabledWhenResending() {
        let (sut, spy) = makeSut(nextAttempt: 30)
        
        #expect(spy.isCodeInputDisabled == false, "Code input should not be disabled initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        sut.simulateUserTapsResend()
        #expect(spy.isCodeInputDisabled == true, "Code input should be disabled after resending starts.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.isCodeInputDisabled == false, "Code input should not be disabled after error.")
        
        sut.simulateUserTapsResend()
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 4), index: 1)
        #expect(spy.isCodeInputDisabled == false, "Code input should not be disabled after success.")
    }
    
    // MARK: Submission
    
    @Test func submissionRequest() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.remote.requests.isEmpty, "There should be no requests initially.")
        
        sut.simulateUserEntersOtp("452")
        #expect(spy.remote.requests.isEmpty, "There should be no requests before the user enters full code.")
        
        sut.simulateUserEntersOtp("4523")
        expectSubmitRequestIsCorrect(spy.remote.requests[0], code: "4523", "There should be a request when the user enters full code")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.remote.requests.count == 1, "There should be no new requests after receiving error.")
        
        sut.simulateUserEntersOtp("5432")
        expectSubmitRequestIsCorrect(spy.remote.requests[1], code: "5432", "There should be a new request when the user enters a full code")
    }
    
    @Test func submissionLoadingIndicator() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.isSubmittionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator initially.")
        
        sut.simulateUserEntersOtp("4523")
        #expect(spy.isSubmittionLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user enters otp.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.isSubmittionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after receiving error.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.isSubmittionLoadingIndicatorDisplayed == true, "There should be a submission loading indicator after the user enters otp.")
        
        spy.remote.finishWith(response: successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.isSubmittionLoadingIndicatorDisplayed == false, "There should be no submission loading indicator after receiving error.")
    }
    
    @Test func submissionGeneralError() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.generalError == nil, "There should be no general error initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.generalError == nil, "There should be no general error after user submits otp.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.generalError == RemoteStrings.values.system, "There should be a general error after request failure.")
        
        sut.simulateUserEntersOtp("4321")
        #expect(spy.generalError == nil, "There should be no general error when user submits new otp.")
        
        spy.remote.finishWith(response: submitGeneralError("general error"), index: 1)
        #expect(spy.generalError == "general error", "There should be a general error after receiving remote error.")
        
        sut.simulateUserEntersOtp("4654")
        spy.remote.finishWith(response: successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 2)
        #expect(spy.generalError == nil, "There should be no general error after success.")
    }
    
    @Test func submissionValidationError() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.validationError == nil, "There should be no validation error initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.validationError == nil, "There should be no validation error after user submits otp.")
        
        spy.remote.finishWith(response: submitValidationError("validation error"), index: 0)
        #expect(spy.validationError == "validation error", "There should be a validation error after receiving backend error.")
        
        sut.simulateUserEntersOtp("4567")
        spy.remote.finishWith(response: successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.validationError == nil, "There should be no validation error after success.")
    }
    
    @Test func otpLength() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        #expect(spy.otpLength == 4, "Otp length should be set initially.")
        
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.otpLength == 4, "Otp length should not be changed after some time passed.")
        
        sut.simulateUserTapsResend()
        #expect(spy.otpLength == 4, "Otp length should not be changed after user resends otp.")
        
        spy.remote.finishWith(response: successResendResponse(token: "any", otpLength: 5, next: 10), index: 0)
        #expect(spy.otpLength == 5, "Otp length should be changed after receiving new otp length.")
    }
    
    @Test func resendingButtonIsDisabledDuringSubmission() {
        let (sut, spy) = makeSut(otpLength: 4, nextAttempt: 30)
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.isResendButtonDisabled == true, "Resend button should be disabled after submission starts.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.isResendButtonDisabled == true, "Resend button should be disabled after error because time before resending is not over yet.")
        
        sut.simulateUserEntersOtp("4567")
        spy.timer.simulateTimePassed(seconds: 30)
        #expect(spy.isResendButtonDisabled == true, "Resend button should be disabled during request even if time is over.")
        
        spy.remote.finishWith(response: submitGeneralError("any"), index: 1)
        #expect(spy.isResendButtonDisabled == false, "Resend button should not be disabled after error if time is over.")
        
        sut.simulateUserEntersOtp("7890")
        spy.remote.finishWith(response: successSubmitResponse(accessToken: "any", refreshToken: "any"), index: 2)
        #expect(spy.isResendButtonDisabled == false, "Resend button should not be disabled after success.")
    }
    
    @Test func successMessage() {
        let (sut, spy) = makeSut(otpLength: 4)
        
        #expect(spy.successes.isEmpty, "There should not be success message initially.")
        
        sut.simulateUserEntersOtp("1234")
        #expect(spy.successes.isEmpty, "There should not be success message after user initiates submission.")
        
        spy.remote.finishWithError(index: 0)
        #expect(spy.successes.isEmpty, "There should not be success message after error.")
        
        sut.simulateUserEntersOtp("1234")
        spy.remote.finishWith(response: successSubmitResponse(accessToken: "access", refreshToken: "refresh"), index: 1)
        #expect(spy.successes[0] == successModel(access: "access", refresh: "refresh"), "There should be a message after success")
    }
    
    // MARK: - Helpers
    
    typealias Sut = EnterCodeFeature
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(
        token: String = "any token",
        otpLength: Int = 6,
        nextAttempt: Int = 45,
        _ loc: SourceLocation = #_sourceLocation
    ) -> (Sut, EnterCodeFeatureSpy) {
        let spy = EnterCodeFeatureSpy()
        let env = EnterCodeEnvironment(
            httpClient: spy.remote.load,
            scheduler: DispatchQueue.test.eraseToAnyScheduler(),
            makeTimer: spy.timer.make()
        )
        let events = EnterCodeEvents(onCorrectOtpEnter: spy.keepSuccess)
        let model = EnterCodeResendModel(confirmationToken: token, otpLength: otpLength, nextAttemptAfter: nextAttempt)
        let sut = EnterCodeFeature.make(env: env, events: events, model: model)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, sourceLocation: loc)
        sut.simulateViewAppeared()
        return (sut, spy)
    }
}

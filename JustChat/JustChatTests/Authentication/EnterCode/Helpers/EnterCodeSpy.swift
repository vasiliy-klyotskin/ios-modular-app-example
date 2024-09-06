//
//  EnterCodeSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Foundation
import Combine
@testable import JustChat

final class EnterCodeFeatureSpy {
    var isSubmittionLoadingIndicatorDisplayed = false
    var isResendingLoadingIndicatorDisplayed: Bool { resendButtonConfig.isLoadingIndicatorShown }
    var isResendButtonDisabled: Bool { resendButtonConfig.isInteractionDisabled }
    var isCodeInputDisabled = false
    var generalError: String? = nil
    var validationError: String? = nil
    var timeRemainingUntilNextAttempt = ""
    var showRemainingTime = false
    var otpLength = 0
    var successes = [EnterCodeSubmitModel]()
    
    let remote = RemoteSpy()
    let timer = TimerSpy()
    
    private var cancellables = Set<AnyCancellable>()
    private var resendButtonConfig: ButtonConfig = .loading()

    func startSpying(sut: EnterCodeTests.Sut) {
        sut.$isCodeInputDisabled.bind(\.isCodeInputDisabled, to: self, storeIn: &cancellables)
        sut.$resendButtonConfig.bind(\.resendButtonConfig, to: self, storeIn: &cancellables)
        sut.$isSubmissionIndicatorVisible.bind(\.isSubmittionLoadingIndicatorDisplayed, to: self, storeIn: &cancellables)
        sut.toastVm.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.$validationError.bind(\.validationError, to: self, storeIn: &cancellables)
        sut.$timeRemainingUntilNextAttempt.bind(\.timeRemainingUntilNextAttempt, to: self, storeIn: &cancellables)
        sut.$showTimeUntilNextAttempt.bind(\.showRemainingTime, to: self, storeIn: &cancellables)
        sut.$otpLength.bind(\.otpLength, to: self, storeIn: &cancellables)
    }
    
    func keepSuccess(model: EnterCodeSubmitModel) {
        successes.append(model)
    }
}

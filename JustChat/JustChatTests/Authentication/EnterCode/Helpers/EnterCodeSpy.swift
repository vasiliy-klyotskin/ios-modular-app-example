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
    var isSubmissionLoadingIndicatorDisplayed = false
    var isResendingLoadingIndicatorDisplayed: Bool { resendButtonConfig.isLoadingIndicatorShown }
    var isResendButtonDisabled: Bool { resendButtonConfig.isInteractionDisabled }
    var isCodeInputDimmed = false
    var generalError: String? = nil
    var validationError: String? = nil
    var timeRemainingUntilNextAttempt = ""
    var showRemainingTime = false
    var otpLength = 0
    
    var successes = [EnterCodeSubmitModel]()
    
    let remote = RemoteSpy()
    let timer = TimerSpy()
    let scheduler = DispatchQueue.test
    
    private var cancellables = Set<AnyCancellable>()
    private var resendButtonConfig: ButtonConfig = .loading()

    func startSpying(sut: EnterCodeTests.Sut) {
        sut.codeInputVm.$isDimmed.bind(\.isCodeInputDimmed, to: self, storeIn: &cancellables)
        sut.codeInputVm.$isLoading.bind(\.isSubmissionLoadingIndicatorDisplayed, to: self, storeIn: &cancellables)
        sut.codeInputVm.$error.bind(\.validationError, to: self, storeIn: &cancellables)
        sut.$resendButtonConfig.bind(\.resendButtonConfig, to: self, storeIn: &cancellables)
        sut.toastVm.$message.bind(\.generalError, to: self, storeIn: &cancellables)
        sut.$timeRemainingUntilNextAttempt.bind(\.timeRemainingUntilNextAttempt, to: self, storeIn: &cancellables)
        sut.$showTimeUntilNextAttempt.bind(\.showRemainingTime, to: self, storeIn: &cancellables)
        sut.codeInputVm.$length.bind(\.otpLength, to: self, storeIn: &cancellables)
    }
    
    func keepSuccess(model: EnterCodeSubmitModel) {
        successes.append(model)
    }
    
    func finishRemoteWithError(index: Int) {
        remote.finishWithError(index: index)
        scheduler.advance()
    }
    
    func finishRemoteWith(response: RemoteResponse, index: Int) {
        remote.finishWith(response: response, index: index)
        scheduler.advance()
    }
}

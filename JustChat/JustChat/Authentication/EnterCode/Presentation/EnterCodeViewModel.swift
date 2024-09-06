//
//  EnterCodeViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Combine
import Foundation

final class EnterCodeViewModel: ObservableObject {
    @Published var isSubmissionIndicatorVisible = false
    @Published var isCodeInputDisabled = false
    @Published var resendButtonConfig: ButtonConfig = .standard(title: EnterCodeStrings.resendButton)
    @Published var validationError: String? = nil
    @Published var otpLength: Int = 0
    @Published var timeRemainingUntilNextAttempt: String = ""
    @Published var showTimeUntilNextAttempt: Bool = true
    @Published var code = "" {
        didSet {
            guard code.count == otpLength else { return }
            toastVm.updateMessage(nil)
            validationError = nil
            onNeedSubmit(.init(code: code))
        }
    }
    
    var onNeedSubmit: (EnterCodeSubmitRequest) -> Void = { _ in }
    var onNeedResend: (EnterCodeResendRequest) -> Void = { _ in }

    let toastVm: ToastViewModel
    private let ticker: SecondTicker
    
    private var confirmationToken: String
    private var secondsLeftBeforeResend: Int
    private var isSubmitting = false
    private var isResending = false
    
    init(toastVm: ToastViewModel, ticker: SecondTicker, model: EnterCodeResendModel) {
        self.toastVm = toastVm
        self.ticker = ticker
        self.confirmationToken = model.confirmationToken
        self.otpLength = model.otpLength
        self.secondsLeftBeforeResend = model.nextAttemptAfter
    }
    
    func resend() {
        guard secondsLeftBeforeResend <= 0 else { return }
        toastVm.updateMessage(nil)
        onNeedResend(.init(confirmationToken: confirmationToken))
    }
    
    func updateCode(_ code: String) {
        if code.count == otpLength {
            onNeedSubmit(.init(code: code))
        }
    }
    
    func startResendLoading() {
        isResending = true
        updateCodeInput()
        updateResendButton()
    }
    
    func finishResendLoading() {
        isResending = false
        updateCodeInput()
        updateResendButton()
    }
    
    func updateResendModel(_ resendModel: EnterCodeResendModel) {
        confirmationToken = resendModel.confirmationToken
        secondsLeftBeforeResend = resendModel.nextAttemptAfter
        otpLength = resendModel.otpLength
        updateTimeRemainingUi()
        ticker.start()
    }
    
    func handleResendError(_ error: EnterCodeResendError) {
        toastVm.updateMessage(error.message)
    }
    
    func startSubmitLoading() {
        isSubmitting = true
        updateCodeInput()
        updateResendButton()
    }
    
    func finishSubmitLoading() {
        isSubmitting = false
        updateCodeInput()
        updateResendButton()
    }
    
    private func updateCodeInput() {
        if isSubmitting {
            isSubmissionIndicatorVisible = true
            isCodeInputDisabled = false
        } else if isResending {
            isSubmissionIndicatorVisible = false
            isCodeInputDisabled = true
        } else {
            isSubmissionIndicatorVisible = false
            isCodeInputDisabled = false
        }
    }
    
    private func updateResendButton() {
        let title = EnterCodeStrings.resendButton
        if isSubmitting {
            resendButtonConfig = .inactive(title: title)
        } else if isResending {
            resendButtonConfig = .loading()
        } else if secondsLeftBeforeResend > 0 {
            resendButtonConfig = .inactive(title: title)
        } else {
            resendButtonConfig = .standard(title: title)
        }
    }
    
    func handleSubmitError(_ error: EnterCodeSubmitError) {
        switch error {
        case .general(let message):
            toastVm.updateMessage(message)
        case .validation(let validation):
            validationError = validation
        }
    }

    func processNextTick() {
        if secondsLeftBeforeResend < 0 {
            ticker.invalidate()
            updateResendButton()
        } else {
            secondsLeftBeforeResend -= 1
            updateTimeRemainingUi()
        }
    }
    
    func viewAppeared() {
        guard !ticker.isTicking() else { return }
        guard secondsLeftBeforeResend > 0 else { return }
        updateTimeRemainingUi()
        ticker.start()
    }
    
    private func updateTimeRemainingUi() {
        timeRemainingUntilNextAttempt = formatSecondsToMinutesAndSeconds(secondsLeftBeforeResend - 1)
        updateResendButton()
        showTimeUntilNextAttempt = secondsLeftBeforeResend != 0
    }
    
    private func formatSecondsToMinutesAndSeconds(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

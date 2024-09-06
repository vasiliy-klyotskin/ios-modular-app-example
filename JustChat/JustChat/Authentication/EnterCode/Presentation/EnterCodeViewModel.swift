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
    @Published var showTimeUntilNextAttempt = true
    @Published var code = "" {
        didSet { handleCodeUpdate() }
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
        clearToastMessage()
        onNeedResend(.init(confirmationToken: confirmationToken))
    }

    func updateCode(_ code: String) {
        guard code.count == otpLength else { return }
        onNeedSubmit(.init(code: code))
    }

    func startResendLoading() {
        toggleResending(true)
    }

    func finishResendLoading() {
        toggleResending(false)
    }
    
    func updateResendModel(_ resendModel: EnterCodeResendModel) {
        confirmationToken = resendModel.confirmationToken
        secondsLeftBeforeResend = resendModel.nextAttemptAfter
        otpLength = resendModel.otpLength
        updateResendUI()
        ticker.start()
    }

    func handleResendError(_ error: EnterCodeResendError) {
        showToastMessage(error.message)
    }

    func startSubmitLoading() {
        toggleSubmitting(true)
    }

    func finishSubmitLoading() {
        toggleSubmitting(false)
    }

    func handleSubmitError(_ error: EnterCodeSubmitError) {
        switch error {
        case .general(let message):
            showToastMessage(message)
        case .validation(let validation):
            validationError = validation
        }
    }

    func processNextTick() {
        secondsLeftBeforeResend -= 1
        if secondsLeftBeforeResend <= 0 {
            ticker.invalidate()
        }
        updateResendUI()
    }
    
    func viewAppeared() {
        updateResendUI()
        if !ticker.isTicking(), secondsLeftBeforeResend > 0 {
            ticker.start()
        }
    }

    private func handleCodeUpdate() {
        guard code.count == otpLength else { return }
        clearToastMessage()
        validationError = nil
        onNeedSubmit(.init(code: code))
    }
    
    private func toggleSubmitting(_ isSubmitting: Bool) {
        self.isSubmitting = isSubmitting
        updateUIState()
    }

    private func toggleResending(_ isResending: Bool) {
        self.isResending = isResending
        updateUIState()
    }

    private func updateUIState() {
        updateCodeInput()
        updateResendButton()
    }

    private func updateCodeInput() {
        isSubmissionIndicatorVisible = isSubmitting
        isCodeInputDisabled = isResending
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

    private func updateResendUI() {
        updateTimeRemainingUi()
        updateResendButton()
    }

    private func updateTimeRemainingUi() {
        timeRemainingUntilNextAttempt = formatSecondsToMinutesAndSeconds(secondsLeftBeforeResend - 1)
        showTimeUntilNextAttempt = secondsLeftBeforeResend > 0
    }

    private func formatSecondsToMinutesAndSeconds(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func clearToastMessage() {
        toastVm.updateMessage(nil)
    }

    private func showToastMessage(_ message: String?) {
        toastVm.updateMessage(message)
    }
}

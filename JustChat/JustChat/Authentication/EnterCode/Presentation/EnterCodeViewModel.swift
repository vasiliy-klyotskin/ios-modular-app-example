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
    @Published var timeRemainingUntilNextAttempt: String = ""
    @Published var showTimeUntilNextAttempt = true
    
    var onNeedSubmit: (EnterCodeSubmitRequest) -> Void = { _ in }
    var onNeedResend: (EnterCodeResendRequest) -> Void = { _ in }

    let codeInputVm: CodeInputViewModel
    let toastVm: ToastViewModel
    
    private let ticker: SecondTicker
    
    private var confirmationToken: String
    private var secondsLeftBeforeResend: Int
    private var isSubmitting = false
    private var isResending = false
    
    init(
        model: EnterCodeResendModel,
        codeInputVm: CodeInputViewModel,
        toastVm: ToastViewModel,
        ticker: SecondTicker
    ) {
        self.toastVm = toastVm
        self.codeInputVm = codeInputVm
        self.ticker = ticker
        self.confirmationToken = model.confirmationToken
        self.secondsLeftBeforeResend = model.nextAttemptAfter
    }
    
    func resend() {
        guard secondsLeftBeforeResend <= 0 else { return }
        toastVm.updateMessage(nil)
        onNeedResend(.init(confirmationToken: confirmationToken))
    }

    func startResendLoading() {
        isResending = true
        updateUIState()
    }

    func finishResendLoading() {
        isResending = false
        updateUIState()
    }
    
    func updateResendModel(_ resendModel: EnterCodeResendModel) {
        confirmationToken = resendModel.confirmationToken
        secondsLeftBeforeResend = resendModel.nextAttemptAfter
        codeInputVm.updateLength(resendModel.otpLength)
        updateResendUI()
        ticker.start()
    }

    func handleResendError(_ error: EnterCodeResendError) {
        toastVm.updateMessage(error.message)
    }

    func startSubmitLoading() {
        isSubmitting = true
        updateUIState()
    }

    func finishSubmitLoading() {
        isSubmitting = false
        updateUIState()
    }

    func handleSubmitError(_ error: EnterCodeSubmitError) {
        switch error {
        case .general(let message):
            toastVm.updateMessage(message)
        case .validation(let validation):
            validationError = validation
        }
    }

    func handleNextTick() {
        secondsLeftBeforeResend -= 1
        if secondsLeftBeforeResend <= 0 {
            ticker.invalidate()
        }
        updateResendUI()
    }
    
    func handleViewAppear() {
        updateResendUI()
        if !ticker.isTicking(), secondsLeftBeforeResend > 0 {
            ticker.start()
        }
    }

    func handleEnteredCode(_ code: String) {
        toastVm.updateMessage(nil)
        validationError = nil
        onNeedSubmit(.init(code: code, confirmationToken: confirmationToken))
    }

    private func updateUIState() {
        isSubmissionIndicatorVisible = isSubmitting
        isCodeInputDisabled = isResending
        updateResendButton()
    }
    
    private func updateResendUI() {
        updateTimeRemainingUi()
        updateResendButton()
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
    
    private func updateTimeRemainingUi() {
        timeRemainingUntilNextAttempt = formatSecondsToMinutesAndSeconds(secondsLeftBeforeResend - 1)
        showTimeUntilNextAttempt = secondsLeftBeforeResend > 0
    }

    private func formatSecondsToMinutesAndSeconds(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

//
//  EnterCodeViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Combine
import Foundation

final class EnterCodeViewModel: ObservableObject {
    var onNeedSubmit: (EnterCodeSubmitRequest) -> Void = { _ in }
    var onNeedResend: (EnterCodeResendRequest) -> Void = { _ in }
    
    @Published private(set) var resendButtonConfig: ButtonConfig = .standard(title: EnterCodeStrings.resendButton)
    @Published private(set) var timeRemainingUntilNextAttempt: String = ""
    @Published private(set) var showTimeUntilNextAttempt = true
    
    let codeInput: CodeInputViewModel
    let toast: ToastViewModel
    private let ticker: SecondTicker
    
    private var confirmationToken: String
    private var secondsLeftBeforeResend: Int
    private var isSubmitting = false
    private var isResending = false
    
    init(
        model: EnterCodeResendModel,
        codeInput: CodeInputViewModel,
        toast: ToastViewModel,
        ticker: SecondTicker
    ) {
        self.toast = toast
        self.codeInput = codeInput
        self.ticker = ticker
        self.confirmationToken = model.confirmationToken
        self.secondsLeftBeforeResend = model.nextAttemptAfter
    }
    
    func resend() {
        guard secondsLeftBeforeResend <= 0 else { return }
        toast.updateMessage(nil)
        codeInput.updateError(nil)
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
        codeInput.updateLength(resendModel.otpLength)
        updateResendUI()
        codeInput.clearInput()
        ticker.start()
    }

    func handleResendError(_ error: EnterCodeResendError) {
        toast.updateMessage(error.message)
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
        codeInput.clearInput()
        switch error {
        case .general(let message):
            toast.updateMessage(message)
        case .validation(let validation):
            codeInput.updateError(validation)
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
        toast.updateMessage(nil)
        onNeedSubmit(.init(code: code, confirmationToken: confirmationToken))
    }

    private func updateUIState() {
        codeInput.updateIsLoading(isSubmitting)
        codeInput.updateIsDimmed(isResending)
        codeInput.updateIsDisabled(isSubmitting || isResending)
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

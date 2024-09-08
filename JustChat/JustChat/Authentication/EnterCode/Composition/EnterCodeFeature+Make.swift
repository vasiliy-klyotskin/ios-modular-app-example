//
//  EnterCodeFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine

extension EnterCodeFeature {
    static func make(env: EnterCodeEnvironment, events: EnterCodeEvents, model: EnterCodeResendModel) -> EnterCodeFeature {
        let ticker = SecondTicker(makeTimer: env.makeTimer)
        let codeInputVm = CodeInputViewModel(length: model.otpLength)
        let vm = EnterCodeViewModel(
            model: model,
            codeInputVm: codeInputVm,
            toastVm: .make(scheduler: env.scheduler),
            ticker: ticker)
        vm.onNeedResend = start(resend <~ env <~ vm)
        vm.onNeedSubmit = start(submit <~ env <~ events <~ vm)
        codeInputVm.onCodeIsEntered = Weak(vm).do { $0.handleEnteredCode }
        ticker.onTick = Weak(vm).do { $0.handleNextTick }
        return vm
    }
    
    private static func resend(
        env: EnterCodeEnvironment,
        vm: Weak<EnterCodeViewModel>,
        request: EnterCodeResendRequest
    ) -> AnyPublisher<EnterCodeResendModel, EnterCodeResendError> {
        env.httpClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(EnterCodeResendError.fromRemoteError)
            .map(EnterCodeResendModel.fromDto)
            .onSubscription(vm.do { $0.startResendLoading })
            .onCompletion(vm.do { $0.finishResendLoading })
            .onFailure(vm.do { $0.handleResendError })
            .onOutput(vm.do { $0.updateResendModel })
            .eraseToAnyPublisher()
    }
    
    private static func submit(
        env: EnterCodeEnvironment,
        events: EnterCodeEvents,
        vm: Weak<EnterCodeViewModel>,
        request: EnterCodeSubmitRequest
    ) -> AnyPublisher<EnterCodeSubmitModel, EnterCodeSubmitError> {
        env.httpClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(EnterCodeSubmitError.fromRemoteError)
            .map(EnterCodeSubmitModel.fromDto)
            .onSubscription(vm.do { $0.startSubmitLoading })
            .onCompletion(vm.do { $0.finishSubmitLoading })
            .onFailure(vm.do { $0.handleSubmitError })
            .onOutput(events.onCorrectOtpEnter)
            .eraseToAnyPublisher()
    }
}

//
//  EnterCodeFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine

extension EnterCodeFeature {
    func view() -> EnterCodeView { .init(vm: self) }
    
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
            .receive(on: env.scheduler)
            .onLoadingStart(vm.do { $0.startResendLoading })
            .onLoadingFinish(vm.do { $0.finishResendLoading })
            .onLoadingFailure(vm.do { $0.handleResendError })
            .onLoadingSuccess(vm.do { $0.updateResendModel })
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
            .receive(on: env.scheduler)
            .onLoadingStart(vm.do { $0.startSubmitLoading })
            .onLoadingFinish(vm.do { $0.finishSubmitLoading })
            .onLoadingFailure(vm.do { $0.handleSubmitError })
            .onLoadingSuccess(events.onCorrectOtpEnter)
            .eraseToAnyPublisher()
    }
}

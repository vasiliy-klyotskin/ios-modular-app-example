//
//  EnterCodeFeature+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine
import CompositionSupport

extension EnterCodeFeature {
    static func make(env: EnterCodeEnvironment, events: EnterCodeEvents, model: EnterCodeResendModel) -> EnterCodeFeature {
        let ticker = SecondTicker(makeTimer: env.makeTimer)
        let codeInputVm = CodeInputViewModel(length: model.otpLength)
        let vm = EnterCodeViewModel(
            model: model,
            codeInput: codeInputVm,
            toast: env.toast,
            ticker: ticker
        )
        vm.onNeedResend = start(resend <~ env <~ vm)
        vm.onNeedSubmit = start(submit <~ env <~ events <~ vm)
        codeInputVm.onCodeIsEntered = Weak(vm).do { $0.handleEnteredCode }
        ticker.onTick = Weak(vm).do { $0.handleNextTick }
        return vm
    }
    
    func view() -> EnterCodeView {
        .init(vm: self)
    }
    
    private static func resend(
        env: EnterCodeEnvironment,
        vm: Weak<EnterCodeViewModel>,
        request: EnterCodeResendRequest
    ) -> AnyPublisher<EnterCodeResendModel, EnterCodeResendError> {
        env.remoteClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(EnterCodeResendError.fromRemoteError)
            .map(EnterCodeResendModel.fromDto)
            .receive(on: env.uiScheduler)
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
        env.remoteClient(request.remote)
            .mapResponseToDtoAndRemoteError()
            .mapError(EnterCodeSubmitError.fromRemoteError)
            .map(EnterCodeSubmitModel.fromDto)
            .receive(on: env.uiScheduler)
            .onLoadingStart(vm.do { $0.startSubmitLoading })
            .onLoadingFinish(vm.do { $0.finishSubmitLoading })
            .onLoadingFailure(vm.do { $0.handleSubmitError })
            .onLoadingSuccess(events.onCorrectOtpEnter)
            .eraseToAnyPublisher()
    }
}

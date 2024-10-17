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
        let weakVm = Weak(vm)
        vm.onNeedResend = start(resend <~ env <~ vm)
        vm.onNeedSubmit = start(submit <~ env <~ events <~ vm)
        codeInputVm.onCodeIsEntered = { weakVm.obj?.handleEnteredCode($0) }
        ticker.onTick = { weakVm.obj?.handleNextTick() }
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
            .onLoadingStart { vm.obj?.startResendLoading() }
            .onLoadingFinish { vm.obj?.finishResendLoading() }
            .onLoadingFailure { vm.obj?.handleResendError($0) }
            .onLoadingSuccess { vm.obj?.updateResendModel($0) }
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
            .onLoadingStart { vm.obj?.startSubmitLoading() }
            .onLoadingFinish { vm.obj?.finishSubmitLoading() }
            .onLoadingFailure { vm.obj?.handleSubmitError($0) }
            .onLoadingSuccess(events.onCorrectOtpEnter)
            .eraseToAnyPublisher()
    }
}

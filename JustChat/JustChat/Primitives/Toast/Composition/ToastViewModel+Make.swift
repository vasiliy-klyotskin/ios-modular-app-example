//
//  ToastComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

extension ToastViewModel {
    static func make(
        error: Published<String?>.Publisher,
        scheduler: AnySchedulerOf<DispatchQueue>
    ) -> ToastViewModel {
        let vm = ToastViewModel()
        let hideToast = cancellingStart(hide <~ scheduler <~ vm)
        let cancellable = error.onOutput(Weak(vm).do { $0.updateError }).sink()
        vm.onNeedHideAfter = captured(cancellable, in: hideToast)
        return vm
    }
    
    private static func hide(
        scheduler: AnySchedulerOf<DispatchQueue>,
        vm: Weak<ToastViewModel>,
        delay: Int
    ) -> AnyPublisher<(), Never> {
        Just(())
            .delay(for: .seconds(delay), scheduler: scheduler)
            .onOutput(vm.do { $0.hideAfterDelay })
            .eraseToAnyPublisher()
    }
}

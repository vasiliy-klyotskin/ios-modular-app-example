//
//  Toast+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import Combine
import Foundation

extension ToastViewModel {
    static func make(scheduler: AnySchedulerOf<DispatchQueue>) -> ToastViewModel {
        let vm = ToastViewModel()
        vm.onNeedHideAfter = cancellingStart(hide <~ scheduler <~ vm)
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

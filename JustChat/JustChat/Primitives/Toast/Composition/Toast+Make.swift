//
//  Toast+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import Combine
import Foundation

extension ToastViewModel {
    static func make(uiScheduler: AnySchedulerOf<DispatchQueue>) -> ToastViewModel {
        let vm = ToastViewModel()
        vm.onNeedHideAfter = cancellingStart(hide <~ uiScheduler <~ vm)
        return vm
    }
    
    private static func hide(
        uiScheduler: AnySchedulerOf<DispatchQueue>,
        vm: Weak<ToastViewModel>,
        delay: Int
    ) -> AnyPublisher<(), Never> {
        Just(())
            .delay(for: .seconds(delay), scheduler: uiScheduler)
            .onLoadingSuccess(vm.do { $0.hideAfterDelay })
            .eraseToAnyPublisher()
    }
}

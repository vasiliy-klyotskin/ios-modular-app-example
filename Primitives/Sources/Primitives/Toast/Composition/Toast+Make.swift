//
//  Toast+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import Combine
import Foundation
import CompositionSupport

extension ToastFeature {
    public static func make(uiScheduler: AnySchedulerOf<DispatchQueue>) -> ToastFeature {
        let vm = ToastViewModel()
        vm.onNeedHideAfter = cancellingStart(hide <~ uiScheduler <~ vm)
        return vm
    }
    
    @MainActor
    public func view() -> Toast {
        .init(vm: self)
    }
    
    private static func hide(
        uiScheduler: AnySchedulerOf<DispatchQueue>,
        vm: Weak<ToastViewModel>,
        delay: Int
    ) -> AnyPublisher<(), Never> {
        Just(())
            .delay(for: .seconds(delay), scheduler: uiScheduler)
            .onLoadingSuccess({ vm.obj?.processTap() })
            .eraseToAnyPublisher()
    }
}

//
//  ToastComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

public extension ToastViewModel {
    static func make(
        error: Published<String?>.Publisher,
        scheduler: AnySchedulerOf<DispatchQueue>
    ) -> ToastViewModel {
        let vm = ToastViewModel()
        var cancellables = Set<AnyCancellable>()
        let hideToast = start(hide <~ scheduler <? vm)
        let updateError = weakify(vm, { $0.updateError })
        error.onOutput(updateError).sink().store(in: &cancellables)
        vm.onNeedHideAfter = captured(cancellables, in: hideToast)
        return vm
    }
    
    private static func hide(
        scheduler: AnySchedulerOf<DispatchQueue>,
        vm: ToastViewModel?,
        delay: Int
    ) -> AnyPublisher<(), Never> {
        Just(())
            .delay(for: .seconds(delay), scheduler: scheduler)
            .onOutput(weakify(vm, { $0.hideAfterDelay }))
            .eraseToAnyPublisher()
    }
}

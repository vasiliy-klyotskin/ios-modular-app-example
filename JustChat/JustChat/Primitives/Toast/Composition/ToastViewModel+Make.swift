//
//  ToastComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

final class ToastStore {
    var hide: Set<AnyCancellable> = []
    var error: Set<AnyCancellable> = []
}

public extension ToastViewModel {
    static func make(
        error: Published<String?>.Publisher,
        scheduler: AnySchedulerOf<DispatchQueue>
    ) -> ToastViewModel {
        let vm = ToastViewModel()
        let store = ToastStore()
        let hideToast = { [weak vm] in
            store.hide = []
            (hide <~ scheduler <~ vm)($0)
                .sink().store(in: &store.hide)
        }
        let updateError = Weak(vm).do { $0.updateError }
        error.onOutput(updateError).sink().store(in: &store.error)
        vm.onNeedHideAfter = captured(store, in: hideToast)
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

//
//  Toast+.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Toast {
    static func preview(message: String? = nil) -> () -> Toast {
        let vm = ToastViewModel()
        vm.updateError(message)
        return { .init(vm: vm) }
    }
}

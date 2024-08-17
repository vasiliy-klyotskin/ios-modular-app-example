//
//  Toast+.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Toast {
    static func preview(message: String? = nil) -> ToastSetup {
        let vm = ToastViewModel()
        vm.updateMessage(message)
        return { .init(vm: vm) }
    }
}

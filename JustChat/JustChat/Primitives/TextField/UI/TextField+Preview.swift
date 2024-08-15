//
//  TextField+Preview.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension TextField {
    static func preview(value: String = "Input value", error: String? = "Input error") -> (Config) -> TextField {
        let vm = TextFieldViewModel()
        vm.input = value
        vm.updateError(error)
        return { config in .init(vm: vm, title: config.title, placeholder: config.title) }
    }
}

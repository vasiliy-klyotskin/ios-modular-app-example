//
//  TextFieldComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

import Combine

public extension TextFieldViewModel {
    static func make(
        error: Published<String?>.Publisher,
        onInput: @escaping (String) -> Void
    ) -> TextFieldViewModel {
        let vm = TextFieldViewModel()
        let cancellable = error.onOutput(Weak(vm).do { $0.updateError }).sink()
        let onInput = captured(cancellable, in: onInput)
        vm.onInputChanged = onInput
        return vm
    }
}

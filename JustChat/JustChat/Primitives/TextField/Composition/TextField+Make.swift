//
//  TextField+Mak.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import Combine

extension TextFieldViewModel {
    func view(title: String) -> TextField {
        .init(vm: self, title: title)
    }
    
    static func make(
        error: Published<String?>.Publisher,
        onInput: @escaping (String) -> Void
    ) -> TextFieldViewModel {
        let vm = TextFieldViewModel()
        let cancellable = error.onOutput(Weak(vm).do { $0.updateError }).sink()
        vm.onInputChanged = captured(cancellable, in: onInput)
        return vm
    }
}

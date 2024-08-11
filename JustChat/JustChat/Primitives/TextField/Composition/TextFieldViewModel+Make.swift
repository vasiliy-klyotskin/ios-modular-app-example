//
//  TextFieldComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

import Combine

extension TextFieldViewModel {
    static func make(
        error: Published<String?>.Publisher,
        onInput: @escaping (String) -> Void
    ) -> TextFieldViewModel {
        let viewModel = TextFieldViewModel()
        let cancellable = error.onOutput(weakify(viewModel, { $0.updateError })).sink()
        let onInput = captured(cancellable, in: onInput)
        viewModel.onInputChanged = onInput
        return viewModel
    }
}

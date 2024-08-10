//
//  ToastComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine

enum ToastComposer {
    static func compose(error: Published<String?>.Publisher) -> ToastViewModel {
        let viewModel = ToastViewModel()
        let cancellable = error.onOutput(weakify(viewModel, { $0.updateError })).sink()
        viewModel.onNeedHideAfter = captured(cancellable, in: { _ in })
        return viewModel
    }
}

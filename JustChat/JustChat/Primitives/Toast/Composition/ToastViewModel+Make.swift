//
//  ToastComposer.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

public extension ToastViewModel {
    static var cancellables = Set<AnyCancellable>()

    static func make(
        error: Published<String?>.Publisher,
        scheduler: AnySchedulerOf<DispatchQueue>
    ) -> ToastViewModel {
        let viewModel = ToastViewModel()
        error.sink(receiveValue: { [weak viewModel] in
            viewModel?.updateError($0)
        }).store(in: &cancellables)
        let action = { [weak viewModel] (delay: Int) in
            Just(())
                .delay(for: .seconds(delay), scheduler: scheduler)
                .eraseToAnyPublisher()
                .sink(receiveValue: { [weak viewModel] in
                    viewModel?.hideAfterDelay()
                })
                .store(in: &cancellables)
        }
        viewModel.onNeedHideAfter = action
        return viewModel
    }
}

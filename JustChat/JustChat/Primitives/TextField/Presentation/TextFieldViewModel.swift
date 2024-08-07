//
//  TextFieldViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class TextFieldViewModel: ObservableObject {
    @Published public var error: String? = nil
    @Published public var input: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private let onInput: (String) -> Void
    
    init(errorPublisher: Published<String?>.Publisher, onInput: @escaping (String) -> Void) {
        self.onInput = onInput
        bindErrorPublisher(errorPublisher)
        bindInput()
    }
    
    private func bindErrorPublisher(_ errorPublisher: Published<String?>.Publisher) {
        errorPublisher
            .sink { [weak self] in
                self?.error = $0
            }
            .store(in: &cancellables)
    }

    private func bindInput() {
        $input
            .dropFirst()
            .sink { [weak self] in
                self?.handleInputChange($0)
            }
            .store(in: &cancellables)
    }
    
    private func handleInputChange(_ input: String) {
        error = nil
        onInput(input)
    }
}

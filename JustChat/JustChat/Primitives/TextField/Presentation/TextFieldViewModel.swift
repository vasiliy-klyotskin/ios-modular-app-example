//
//  TextFieldViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

final class TextFieldViewModel: ObservableObject {
    @Published var error: String? = nil
    @Published var input: String = "" {
        didSet { handle(input: input) }
    }
    
    var onInputChanged: (String) -> Void = { _ in }
    
    var isError: Bool {
        error != nil
    }
    
    var isTitleShown: Bool {
        !input.isEmpty
    }
    
    var isClearButtonShown: Bool {
        !input.isEmpty
    }

    func updateError(_ error: String?) {
        self.error = error
    }
    
    func clear() {
        input = ""
    }
    
    private func handle(input: String) {
        error = nil
        onInputChanged(input)
    }
}

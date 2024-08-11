//
//  TextFieldViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class TextFieldViewModel: ObservableObject {
    @Published public var isTitleShown: Bool = false
    @Published public var error: String? = nil
    @Published public var input: String = "" {
        didSet { handle(input: input) }
    }
    
    var onInputChanged: (String) -> Void = { _ in }

    func updateError(_ error: String?) {
        self.error = error
    }
    
    public func clear() {
        input = ""
    }
    
    private func handle(input: String) {
        error = nil
        isTitleShown = !input.isEmpty
        onInputChanged(input)
    }
}

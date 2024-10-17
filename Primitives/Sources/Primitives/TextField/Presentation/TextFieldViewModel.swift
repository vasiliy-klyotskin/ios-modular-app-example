//
//  TextFieldViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class TextFieldViewModel: ObservableObject {
    @Published public var error: String? = nil
    @Published public var isError = false
    @Published public var isClearButtonShown = false
    @Published public var input = ""
    
    public init() {}

    public func updateError(_ error: String?) {
        self.error = error
        isError = error != nil
    }
    
    public func clear() {
        input = ""
        error = nil
        isError = false
        isClearButtonShown = false
    }
    
    public func handle(oldInput: String, newInput: String) {
        if oldInput == newInput { return }
        error = nil
        isError = false
        isClearButtonShown = !input.isEmpty
    }
}

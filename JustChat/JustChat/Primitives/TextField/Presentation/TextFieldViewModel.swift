//
//  TextFieldViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

final class TextFieldViewModel: ObservableObject {
    @Published var error: String? = nil
    @Published var isError = false
    @Published var isClearButtonShown = false
    @Published var input = ""

    func updateError(_ error: String?) {
        self.error = error
        isError = error != nil
    }
    
    func clear() {
        input = ""
        error = nil
        isError = false
        isClearButtonShown = false
    }
    
    func handle(oldInput: String, newInput: String) {
        if oldInput == newInput { return }
        error = nil
        isError = false
        isClearButtonShown = !input.isEmpty
    }
}

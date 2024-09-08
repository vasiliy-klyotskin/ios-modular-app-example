//
//  OTPViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/7/24.
//

import Combine

final class CodeInputViewModel: ObservableObject {
    @Published var length: Int
    @Published var isFocused: Bool = true
    @Published var codeInput: String = ""
    
    init(length: Int) {
        self.length = length
    }
    
    var onCodeIsEntered: (String) -> Void = { _ in }
    
    func updateLength(_ value: Int) {
        length = value
    }
    
    func getCharacter(at index: Int) -> String {
        if index < codeInput.count {
            let otpIndex = codeInput.index(codeInput.startIndex, offsetBy: index)
            return String(codeInput[otpIndex])
        }
        return ""
    }
    
    func shouldShowCursor(at index: Int) -> Bool {
        return isFocused && index == codeInput.count && codeInput.count < length
    }
    
    func updateInput(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        if filtered.count > length {
            codeInput = String(filtered.prefix(length))
        } else {
            codeInput = filtered
        }
        if codeInput.count == length {
            onCodeIsEntered(codeInput)
        }
    }
}

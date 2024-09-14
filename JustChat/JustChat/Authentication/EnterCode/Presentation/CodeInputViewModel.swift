//
//  OTPViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/7/24.
//

import Combine
import Foundation

final class CodeInputViewModel: ObservableObject {
    @Published private(set) var length: Int
    @Published private(set) var isDimmed = false
    @Published private(set) var error: String? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private var codeInput = ""
    @Published var rawInput = "" {
        didSet {
            handleInputChange(oldValue: oldValue, newValue: rawInput)
        }
    }
    
    var onCodeIsEntered: (String) -> Void = { _ in }
    
    private var codeAtDisableMoment: String? = nil
    
    init(length: Int) {
        self.length = length
    }

    func updateLength(_ value: Int) {
        length = value
    }
    
    func updateIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func updateIsDimmed(_ isDimmed: Bool) {
        self.isDimmed = isDimmed
    }
    
    func updateError(_ error: String?) {
        self.error = error
    }
    
    func updateIsDisabled(_ isDisabled: Bool) {
        if isDisabled {
            codeAtDisableMoment = codeInput
        } else {
            rawInput = codeAtDisableMoment ?? rawInput
            codeAtDisableMoment = nil
        }
    }
    
    func clearInput() {
        rawInput = ""
    }
    
    func getCharacter(at index: Int) -> String {
        if index < codeInput.count {
            let otpIndex = codeInput.index(codeInput.startIndex, offsetBy: index)
            return String(codeInput[otpIndex])
        }
        return ""
    }
    
    func shouldShowCursor(at index: Int) -> Bool {
        index == codeInput.count && codeInput.count < length
    }
    
    private func handleInputChange(oldValue: String, newValue: String) {
        if codeAtDisableMoment != nil { return }
        error = nil
        setFiltered(newValue: newValue)
        callBackIfCodeIsFullyEntered()
    }
    
    private func setFiltered(newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        let prefixed = String(filtered.prefix(length))
        codeInput = prefixed
    }
    
    private func callBackIfCodeIsFullyEntered() {
        if codeInput.count == length {
            onCodeIsEntered(codeInput)
        }
    }
}

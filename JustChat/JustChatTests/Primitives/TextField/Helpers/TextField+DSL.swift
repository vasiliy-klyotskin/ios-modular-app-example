//
//  TextField+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

@testable import JustChat

extension TextFieldTests.Sut {
    func simulateChangingInput(_ value: String) {
        let oldValue = input
        input = value
        handle(oldInput: oldValue, newInput: value)
    }
}

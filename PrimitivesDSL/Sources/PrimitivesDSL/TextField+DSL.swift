//
//  TextField+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Primitives

extension TextFieldViewModel {
    public func simulateChangingInput(_ value: String) {
        let oldValue = input
        input = value
        handle(oldInput: oldValue, newInput: value)
    }
}

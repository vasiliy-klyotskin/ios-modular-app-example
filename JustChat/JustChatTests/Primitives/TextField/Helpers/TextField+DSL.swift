//
//  TextField+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

@testable import JustChat

extension TextFieldTests.Sut {
    func simulateChangingInput(_ newInput: String) {
        input = newInput
    }
}

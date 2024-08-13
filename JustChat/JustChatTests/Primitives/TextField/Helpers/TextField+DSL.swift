//
//  TextField+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

@testable import JustChat

extension TextFieldTests.Sut {
    func changeInput(_ newInput: String) {
        self.input = newInput
    }
}

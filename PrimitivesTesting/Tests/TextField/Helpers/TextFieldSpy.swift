//
//  TextFieldSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import CompositionTestingTools

final class TextFieldSpy {
    var error: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func startSpying(sut: TextFieldTests.Sut) {
        sut.$error.bind(\.error, to: self, storeIn: &cancellables)
    }
}

//
//  TextFieldSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine

final class TextFieldSpy {
    @Published var externalError: String?
    
    var internalError: String?
    var onInputCalls: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func startSpying(sut: TextFieldTests.Sut) {
        sut.$error.bind(\.internalError, to: self, storeIn: &cancellables)
    }
    
    func appendInputCall(_ input: String) {
        onInputCalls.append(input)
    }
}

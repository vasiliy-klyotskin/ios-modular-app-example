//
//  ToastSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation
@testable import JustChat

final class ToastSpy {
    var message: String?
    
    private let uiScheduler: TestSchedulerOf<DispatchQueue>
    
    init(uiScheduler: TestSchedulerOf<DispatchQueue>) {
        self.uiScheduler = uiScheduler
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func startSpying(sut: ToastTests.Sut) {
        sut.$message.bind(\.message, to: self, storeIn: &cancellables)
    }
    
    func simulateTimePassed(seconds: Int) {
        uiScheduler.advance(by: .init(integerLiteral: seconds))
    }
}

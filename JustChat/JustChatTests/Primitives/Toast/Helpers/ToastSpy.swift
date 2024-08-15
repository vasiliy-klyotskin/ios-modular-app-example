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
    @Published var externalError: String?
    var internalError: String?
    
    private let scheduler: TestSchedulerOf<DispatchQueue>
    
    init(scheduler: TestSchedulerOf<DispatchQueue>) {
        self.scheduler = scheduler
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func startSpying(sut: ToastTests.Sut) {
        sut.$message.bind(\.internalError, to: self, storeIn: &cancellables)
    }
    
    func simulateTimePassed(seconds: Int) {
        scheduler.advance(by: .init(integerLiteral: seconds))
    }
}

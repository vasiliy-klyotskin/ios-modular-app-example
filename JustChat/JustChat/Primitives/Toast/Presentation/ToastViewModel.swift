//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class ToastViewModel {
    @Published public var error: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ errorPublisher: Published<String?>.Publisher) {
        errorPublisher.sink(receiveValue: { [weak self] error in
            self?.error = error
        }).store(in: &cancellables)
    }
    
    public func processTap() {
        error = nil
    }
}

//
//  Combine+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine

extension Published.Publisher {
    public func bind<Root>(
        _ keyPath: ReferenceWritableKeyPath<Root, Value>,
        to target: Root,
        storeIn cancellables: inout Set<AnyCancellable>
    ) where Root: AnyObject {
        self
            .sink { [weak target] value in
                target?[keyPath: keyPath] = value
            }
            .store(in: &cancellables)
    }
}

//
//  Button+Preview.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Button {
    static func preview() -> (Config) -> Button {
        { .init(title: $0.title, isLoading: $0.isLoading, action: {}) }
    }
}
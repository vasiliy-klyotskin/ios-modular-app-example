//
//  Button+Preview.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Button {
    static func preview(config: Button.Config) -> Button {
        Button(title: config.title, isLoading: config.isLoading, action: {})
    }
}

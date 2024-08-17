//
//  LinkButton+Preview.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension LinkButton {
    static func preview() -> LinkButtonSetup {
        { .init(title: $0.title, action: {}) }
    }
}

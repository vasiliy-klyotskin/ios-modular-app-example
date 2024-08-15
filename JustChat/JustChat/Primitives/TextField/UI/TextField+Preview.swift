//
//  TextField+Preview.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension TextField {
    static func preview(config: TextField.Config) -> TextField {
        .init(vm: .init(), title: config.title, placeholder: config.title)
    }
}

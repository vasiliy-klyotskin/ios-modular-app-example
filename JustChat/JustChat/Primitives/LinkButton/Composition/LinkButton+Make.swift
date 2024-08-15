//
//  LinkButton+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

extension LinkButton {
    static func make(action: @escaping () -> Void, config: LinkButton.Config) -> LinkButton {
        .init(title: config.title, action: action)
    }
}

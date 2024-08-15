//
//  TextField+Mak.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

extension TextField {
    static func make(vm: TextFieldViewModel, config: TextField.Config) -> TextField {
        TextField(vm: vm, title: config.title, placeholder: config.title)
    }
}

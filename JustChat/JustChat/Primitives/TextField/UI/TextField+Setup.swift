//
//  TextField+Config.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

typealias TextFieldSetup = (TextField.Config) -> TextField

extension TextField {
    struct Config {
        let title: String
    }
}

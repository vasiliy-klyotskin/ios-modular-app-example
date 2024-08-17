//
//  LinkButton+Config.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

typealias LinkButtonSetup = (LinkButton.Config) -> LinkButton

extension LinkButton {
    struct Config {
        let title: String
    }
}

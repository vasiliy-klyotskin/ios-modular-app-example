//
//  Button+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

import SwiftUI

extension Button {
    static func make(action: @escaping () -> Void, config: Button.Config) -> Button {
        Button(title: config.title, isLoading: config.isLoading, action: action)
    }
}

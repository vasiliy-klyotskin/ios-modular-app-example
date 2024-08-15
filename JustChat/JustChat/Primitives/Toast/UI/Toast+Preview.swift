//
//  Toast+.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Toast {
    static func preview(message: String? = nil) -> () -> Toast {{
        .init(vm: .init(error: message))
    }}
}

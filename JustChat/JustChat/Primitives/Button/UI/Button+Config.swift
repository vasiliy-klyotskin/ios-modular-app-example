//
//  Button+Config.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

extension Button {
    struct Config {
        let title: String
        let isLoading: Bool
        
        init(title: String, isLoading: Bool = false) {
            self.title = title
            self.isLoading = isLoading
        }
    }
}

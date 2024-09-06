//
//  ButtonConfig.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine

struct ButtonConfig {
    let title: String
    let isLoadingIndicatorShown: Bool
    let textAlpha: Double
    let contentAlpha: Double
    let isInteractionDisabled: Bool
    
    static func standard(title: String) -> ButtonConfig {
        .init(title: title, isLoadingIndicatorShown: false, textAlpha: 1, contentAlpha: 1, isInteractionDisabled: false)
    }
    
    static func loading() -> ButtonConfig {
        .init(title: "", isLoadingIndicatorShown: true, textAlpha: 0, contentAlpha: 1, isInteractionDisabled: true)
    }
    
    static func inactive(title: String) -> ButtonConfig {
        .init(title: title, isLoadingIndicatorShown: false, textAlpha: 1, contentAlpha: 0.7, isInteractionDisabled: true)
    }
}

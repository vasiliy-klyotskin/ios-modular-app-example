//
//  ButtonConfig.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Combine

public struct ButtonConfig {
    public let title: String
    public let isLoadingIndicatorShown: Bool
    public let textAlpha: Double
    public let contentAlpha: Double
    public let isInteractionDisabled: Bool
    
    public static func standard(title: String) -> ButtonConfig {
        .init(title: title, isLoadingIndicatorShown: false, textAlpha: 1, contentAlpha: 1, isInteractionDisabled: false)
    }
    
    public static func loading() -> ButtonConfig {
        .init(title: "@", isLoadingIndicatorShown: true, textAlpha: 0, contentAlpha: 1, isInteractionDisabled: true)
    }
    
    public static func inactive(title: String) -> ButtonConfig {
        .init(title: title, isLoadingIndicatorShown: false, textAlpha: 1, contentAlpha: 0.7, isInteractionDisabled: true)
    }
}

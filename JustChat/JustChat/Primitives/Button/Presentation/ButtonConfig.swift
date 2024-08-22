//
//  ButtonConfig.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/22/24.
//

struct ButtonConfig {
    let title: String
    let isLoadingIndicatorShown: Bool
    let textAlpha: Double
    let contentAlpha: Double
    let isLoadingDisplayed: Bool
    let isInteractionDisabled: Bool
    
    static func standard(title: String, isLoading: Bool = false, isDimmed: Bool = false) -> ButtonConfig {
        .init(
            title: title,
            isLoadingIndicatorShown: isLoading,
            textAlpha: isLoading ? 0 : 1,
            contentAlpha: isDimmed ? 0.7 : 1,
            isLoadingDisplayed: isLoading,
            isInteractionDisabled: isLoading || isDimmed
        )
    }
}

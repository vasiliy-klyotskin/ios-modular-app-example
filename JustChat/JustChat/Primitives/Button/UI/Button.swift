//
//  Button.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct Button: View {
    let action: () -> Void
    let config: ButtonConfig
    
    var body: some View {
        SwiftUI.Button(action: action) {
            ZStack {
                Text(config.title)
                    .opacity(config.textAlpha)
                    .font(UI.font.bold.headline)
                if config.isLoadingDisplayed {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(UI.color.text.primaryInverted)
                }
            }
            .padding(UI.spacing.md)
            .foregroundStyle(UI.color.text.primaryInverted)
            .frame(maxWidth: .infinity)
            .background(background())
        }
        .opacity(config.contentAlpha)
        .disabled(config.isInteractionDisabled)
    }
    
    private func background() -> some View {
        RoundedRectangle(cornerRadius: UI.radius.corner.md)
            .fill(UI.color.main.primary)
            .shadow(
                color: UI.color.shadow.primary,
                radius: UI.radius.shadow.sm,
                y: UI.elevation.md
            )
    }
}

#Preview {
    VStack(spacing: UI.spacing.md) {
        Button(action: {}, config: .standard(title: "Let's go", isLoading: true, isDimmed: false))
        Button(action: {}, config: .standard(title: "Let's go", isLoading: false, isDimmed: false))
        Button(action: {}, config: .standard(title: "Let's go", isLoading: true, isDimmed: true))
        Button(action: {}, config: .standard(title: "Let's go", isLoading: false, isDimmed: true))
    }
    .padding(UI.spacing.md)
    .background(UI.color.background.primary)
}

//
//  Button.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct Button: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        SwiftUI.Button(action: action) {
            ZStack {
                Text(title)
                    .opacity(isLoading ? 0 : 1)
                    .font(UI.font.bold.headline)
                if isLoading {
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
        .disabled(isLoading)
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
        Button.preview()(.init(title: "Continue", isLoading: false))
        Button.preview()(.init(title: "Let's go", isLoading: true))
    }
    .padding(UI.spacing.md)
    .background(UI.color.background.primary)
}

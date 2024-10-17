//
//  OAuthLoginButton.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import SwiftUI
import DesignScheme

struct GoogleAuthButton: View {
    @ScaledMetric(wrappedValue: 24, relativeTo: .body) var iconSize: CGFloat
    
    let action: () -> Void
    let title: String
    
    init(action: @escaping () -> Void, title: String) {
        self.action = action
        self.title = title
    }
    
    var body: some View {
        SwiftUI.Button(action: action) {
            HStack {
                Spacer()
                Image(.gLogo)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                Text(title)
                    .font(UI.font.bold.headline)
                    .foregroundColor(UI.color.text.primary)
                    .padding(.vertical, UI.spacing.md)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(UI.radius.corner.md)
            .background(
                RoundedRectangle(cornerRadius: UI.radius.corner.md)
                    .fill(UI.color.surface.primary)
                    .shadow(
                        color: UI.color.shadow.primary.opacity(UI.opacity.sm),
                        radius: UI.radius.shadow.md,
                        y: UI.elevation.md
                    )
            )
        }
    }
}

#Preview {
    GoogleAuthButton(action: {}, title: "Sign in with Google")
        .padding(UI.spacing.md)
        .background(UI.color.background.primary)
}

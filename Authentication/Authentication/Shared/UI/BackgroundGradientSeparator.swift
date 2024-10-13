//
//  BackgroundGradientSeparator.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/20/24.
//

import SwiftUI
import DesignScheme

struct BackgroundGradientSeparator: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.clear, UI.color.background.primary]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: UI.spacing.lg)
    }
}

#Preview {
    BackgroundGradientSeparator()
}

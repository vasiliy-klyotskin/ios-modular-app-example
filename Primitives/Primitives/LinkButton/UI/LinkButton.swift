//
//  LinkButton.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI
import DesignScheme

public struct LinkButton: View {
    private let title: String
    private let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            Text(title)
                .font(UI.font.bold.body)
                .foregroundStyle(UI.color.main.secondary)
        }
    }
}

#Preview {
    LinkButton(title: "Let's go", action: {})
        .padding(UI.spacing.md)
        .background(UI.color.background.primary)
}

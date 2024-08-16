//
//  LinkButton.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct LinkButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        SwiftUI.Button(action: action) {
            Text(title)
                .font(UI.font.bold.body)
                .foregroundStyle(UI.color.main.secondary)
        }
    }
}

#Preview {
    LinkButton.preview()(.init(title: "Let's go"))
        .padding(UI.spacing.md)
        .background(UI.color.background.primary)
}

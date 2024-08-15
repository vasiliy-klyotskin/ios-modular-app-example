//
//  LinkButton.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

public struct LinkButton: View {
    private let title: String
    private let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            Text(title)
        }
    }
}

#Preview {
    LinkButton.preview(config: .init(title: "Let's go"))
}

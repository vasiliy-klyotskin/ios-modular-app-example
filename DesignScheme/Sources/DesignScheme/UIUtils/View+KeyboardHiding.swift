//
//  View+KeyboardHiding.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import SwiftUI

extension View {
    public func hideKeyboardOnTap() -> some View {
        onTapGesture {
            self.hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        window.endEditing(true)
    }
}

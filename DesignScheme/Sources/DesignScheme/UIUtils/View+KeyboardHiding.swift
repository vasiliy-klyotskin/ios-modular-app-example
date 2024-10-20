//
//  View+KeyboardHiding.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import SwiftUI

extension View {
    public func hideKeyboardOnTap() -> some View {
        onAppear(perform: KeyboardClosingUIGestureRecognizer.connectToKeyWindow)
    }
}

final class KeyboardClosingUIGestureRecognizer: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    static func connectToKeyWindow() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
        guard let keyWindow else { return }
        let tapGesture = KeyboardClosingUIGestureRecognizer(target: keyWindow, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = tapGesture
        keyWindow.addGestureRecognizer(tapGesture)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

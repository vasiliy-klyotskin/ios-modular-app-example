//
//  PresentationContextProvider.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/16/24.
//

import AuthenticationServices

final class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    override init() {
        super.init()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                return window
            }
        }
        return ASPresentationAnchor()
    }
}

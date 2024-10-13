//
//  Navigation.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import SwiftUI
import DesignScheme

public struct AuthenticationView: View {
    @ObservedObject var flow: AuthenticationFlow

    public var body: some View {
        NavigationStack(path: $flow.path) {
            flow.root.view()
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .optionalOverlay { flow.googleOAuthFeature?.view() }
                .navigationDestination(for: AuthenticationFlow.Path.self, destination: destination(path:))
        }
        .tint(UI.color.text.primary)
    }
    
    @ViewBuilder
    private func destination(path: AuthenticationFlow.Path) -> some View {
        Group {
            switch path {
            case .enterCode(let screen): screen.feature.view()
            case .register(let screen): screen.feature.view()
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}

private extension View {
    func optionalOverlay<OverlayContent: View>(@ViewBuilder content: @escaping () -> OverlayContent?) -> some View {
        self.overlay { content().map { AnyView($0) } ?? AnyView(EmptyView()) }
    }
}

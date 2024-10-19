//
//  AuthenticationDemoApp.swift
//  AuthenticationDemo
//
//  Created by Василий Клецкин on 9/29/24.
//

import SwiftUI
import Combine

@main
struct AuthenticationDemoApp: App {
    @State var authenticationDemo: AuthenticationDemoFeature? = nil

    private func restartDemo() {
        authenticationDemo = AuthenticationDemoFeature.make(events: .init(onNeedToRestartDemo: restartDemo))
    }

    var body: some Scene {
        WindowGroup {
            contentView.onAppear(perform: restartDemo)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if let demo = authenticationDemo {
            demo.view()
        }
    }
}

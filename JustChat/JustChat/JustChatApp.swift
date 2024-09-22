//
//  JustChatApp.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/6/24.
//

import SwiftUI
import Combine
import AuthenticationServices

@main
struct JustChatApp: App {
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

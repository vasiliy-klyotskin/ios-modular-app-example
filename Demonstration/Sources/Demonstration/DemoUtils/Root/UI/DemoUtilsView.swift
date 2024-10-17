//
//  DemoUtilsView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import SwiftUI

public struct DemoUtilsView: View {
    @ObservedObject var flow: DemoUtilsFlow
    
    public var body: some View {
        EmptyView()
            .sheet(isPresented: $flow.isSheetPresented, content: navigationStack)
    }
    
    private func navigationStack() -> some View {
        NavigationStack(path: $flow.path) {
            flow.root.view()
                .navigationTitle(Text(flow.navbarTitle))
                .navigationDestination(for: DemoUtilsFlow.Path.self, destination: destination(path:))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func destination(path: DemoUtilsFlow.Path) -> some View {
        Group {
            switch path {
            case .editRequest(let screen):
                screen.feature.view()
                    .navigationTitle(screen.feature.navbarTitle)
            case .requests(let screen):
                screen.feature.view()
                    .navigationTitle(screen.feature.navbarTitle)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

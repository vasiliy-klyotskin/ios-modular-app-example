//
//  OAuthView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import SwiftUI

struct OAuthView: View {
    @ObservedObject var vm: OAuthViewModel
    
    private let loadingIndicatorSizeCoef: CGFloat = 1.4
    private let loadingIndicatorBoxSize: CGFloat = 80
    private let backgroundOpacity: CGFloat = 0.5
    
    var body: some View {
        if vm.isLoadingIndicatorVisible {
            ZStack {
                Color.black.opacity(backgroundOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
                Rectangle()
                    .fill(UI.color.surface.primary)
                    .frame(width: loadingIndicatorBoxSize, height: loadingIndicatorBoxSize)
                    .clipShape(RoundedRectangle(cornerSize: .init(
                        width: UI.radius.corner.md,
                        height: UI.radius.corner.md)))
                ProgressView()
                    .scaleEffect(loadingIndicatorSizeCoef)
                    .tint(UI.color.text.primary)
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}

#Preview {
    let vm = OAuthViewModel(toast: .init())
    vm.displayLoadingStart()
    return OAuthView(vm: vm)
}

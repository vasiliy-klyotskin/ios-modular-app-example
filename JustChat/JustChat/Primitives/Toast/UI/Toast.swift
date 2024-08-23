//
//  Toast.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct Toast: ViewModifier {
    @ObservedObject var vm: ToastViewModel
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if let message = vm.message {
                    toastContent(message: message)
                        .padding(UI.spacing.md)
                }
                Spacer()
            }
        }
    }
    
    private func toastContent(message: String) -> some View {
        HStack {
            Text(message)
                .font(UI.font.bold.headline)
                .foregroundStyle(UI.color.text.primaryInverted)
            Spacer()
        }
        .padding(UI.spacing.lg)
        .frame(maxWidth: .infinity)
        .background(background())
        .onTapGesture(perform: vm.processTap)
    }
    
    private func background() -> some View {
        RoundedRectangle(cornerRadius: UI.radius.corner.md)
            .fill(UI.color.status.error)
    }
}

extension View {
    func showToast(_ toast: Toast) -> some View {
        modifier(toast)
    }
}

#Preview {
    let vm = ToastViewModel()
    vm.updateMessage("Some important message")
    return Rectangle()
        .fill(UI.color.background.primary)
        .ignoresSafeArea()
        .showToast(Toast(vm: vm))
}

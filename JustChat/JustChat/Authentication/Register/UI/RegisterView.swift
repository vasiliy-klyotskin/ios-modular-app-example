//
//  RegisterView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: RegisterViewModel
    let subviews: RegisterSubviews
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content
                    .padding(UI.spacing.md)
                    .frame(minHeight: geometry.size.height)
            }
        }
        .background(UI.color.background.primary)
        .showToast(subviews.toast)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: UI.spacing.lg) {
            Spacer()
            header()
            inputs().padding(.vertical, UI.spacing.md)
            subviews.submitButton(.init(
                title: RegisterStrings.submitButtonTitle,
                isLoading: vm.isLoading
            ))
            login()
        }
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: UI.spacing.md) {
            Text(RegisterStrings.title)
                .font(UI.font.bold.largeTitle)
                .foregroundStyle(UI.color.text.primary)
            Text(RegisterStrings.subtitle)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.secondary)
        }
    }
    
    private func inputs() -> some View {
        VStack(spacing: UI.spacing.xl) {
            subviews.emailInput(.init(title: RegisterStrings.emailInputTitle))
            subviews.usernameInput(.init(title: RegisterStrings.usernameInputTitle))
        }
    }
    
    private func login() -> some View {
        HStack {
            Spacer()
            Text(RegisterStrings.loginText)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
            subviews.loginButton(.init(title: RegisterStrings.loginButtonTitle))
            Spacer()
        }
    }
}

#Preview {
    RegisterView(vm: .init(), subviews: .init(
        usernameInput: TextField.preview(),
        emailInput: TextField.preview(),
        submitButton: Button.preview(),
        loginButton: LinkButton.preview(),
        toast: Toast.preview(message: "General error")
    ))
}

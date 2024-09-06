//
//  RegisterView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: RegisterViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .padding(UI.spacing.md)
                    .frame(minHeight: geometry.size.height)
                    .disabled(vm.isContentDisabled)
            }
        }
        .background(UI.color.background.primary)
        .showToast(Toast(vm: vm.toast))
    }
    
    private func content() -> some View {
        VStack(alignment: .leading, spacing: UI.spacing.lg) {
            Spacer()
            header()
            inputs().padding(.vertical, UI.spacing.md)
            submitButton()
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
            TextField(vm: vm.email, title: RegisterStrings.emailInputTitle)
            TextField(vm: vm.username, title: RegisterStrings.usernameInputTitle)
        }
    }
    
    private func login() -> some View {
        HStack {
            Spacer()
            Text(RegisterStrings.loginText)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
            LinkButton(title: RegisterStrings.loginButtonTitle, action: vm.loginTapped)
            Spacer()
        }
    }
    
    private func submitButton() -> some View {
        Button(onTap: vm.submit, config: vm.submitButtonConfig)
    }
}

#Preview {
    RegisterView(vm: .init(toast: .init()))
}

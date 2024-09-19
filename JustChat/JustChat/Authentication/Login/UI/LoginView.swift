//
//  LoginView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    private var separatorHeight: CGFloat { 1 }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .frame(minHeight: geometry.size.height)
                    
            }
        }
        .background(UI.color.background.primary)
    }
    
    private func content() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            header().padding(.bottom, UI.spacing.lg)
            input().padding(.bottom, UI.spacing.lg)
            submitButton().padding(.bottom, UI.spacing.md)
            separator().padding(.bottom, UI.spacing.md)
            googleAuthButton().padding(.bottom, UI.spacing.lg)
            register()
        }
        .padding(UI.spacing.md)
        .disabled(vm.isContentDisabled)
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: UI.spacing.md) {
            Text(LoginStrings.title)
                .font(UI.font.bold.largeTitle)
                .foregroundStyle(UI.color.text.primary)
            Text(LoginStrings.subtitle)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.secondary)
        }
    }
    
    private func input() -> some View {
        TextField(vm: vm.input, title: LoginStrings.loginTitle)
    }
    
    private func submitButton() -> some View {
        Button(onTap: vm.submit, config: vm.submitButtonConfig)
    }
    
    private func separator() -> some View {
        HStack(spacing: UI.spacing.md) {
            Rectangle().frame(height: separatorHeight)
            Text(LoginStrings.separator).font(UI.font.plain.body)
            Rectangle().frame(height: separatorHeight)
        }
        .foregroundColor(UI.color.separator.primary)
        .opacity(UI.opacity.lg)
        .padding(.horizontal, UI.spacing.md)
    }
    
    private func googleAuthButton() -> some View {
        GoogleAuthButton(action: vm.googleAuthTapped, title: LoginStrings.googleButton)
    }
    
    private func register() -> some View {
        HStack {
            Spacer()
            Text(LoginStrings.registerTitle)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
            LinkButton(title: LoginStrings.registerButton, action: vm.registerTapped)
            Spacer()
        }
    }
}

#Preview {
    LoginView(vm: .init(input: .init(), toast: .init()))
}

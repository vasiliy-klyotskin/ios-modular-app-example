//
//  LoginView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .frame(minHeight: geometry.size.height)
            }
        }
        .background(UI.color.background.primary)
        .showToast(Toast(vm: vm.toast))
    }
    
    private func content() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            header().padding(.bottom, UI.spacing.lg)
            input().padding(.bottom, UI.spacing.lg)
            submitButton().padding(.bottom, UI.spacing.md)
            separator().padding(.bottom, UI.spacing.md)
            googleAuthButton().padding(.bottom, UI.spacing.lg)
            register()
        }
        .padding(UI.spacing.md)
        .disabled(vm.isLoading)
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
        Button(action: vm.submit, config: .standard(title: LoginStrings.continueButton))
    }
    
    private func separator() -> some View {
        HStack(spacing: UI.spacing.md) {
            Rectangle().frame(height: 1)
            Text(LoginStrings.separator).font(UI.font.plain.body)
            Rectangle().frame(height: 1)
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
    LoginView(vm: .init(inputVm: .init(), toastVm: .init()))
}

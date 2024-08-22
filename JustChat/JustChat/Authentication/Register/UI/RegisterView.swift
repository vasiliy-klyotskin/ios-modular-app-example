//
//  RegisterView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: RegisterViewModel
    
    let emailInput: TextFieldSetup
    let usernameInput: TextFieldSetup
    let toast: ToastSetup
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .padding(UI.spacing.md)
                    .frame(minHeight: geometry.size.height)
            }
        }
        .background(UI.color.background.primary)
        .showToast(toast)
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
            emailInput(RegisterStrings.emailInputTitle)
            usernameInput(RegisterStrings.usernameInputTitle)
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
        Button(action: vm.submit, config: .standard(title: RegisterStrings.submitButtonTitle, isLoading: vm.isLoading))
    }
}

#Preview {
    RegisterView(
        vm: .init(),
        emailInput: TextField.preview(),
        usernameInput: TextField.preview(),
        toast: Toast.preview()
    )
}

//
//  LoginView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    let subviews: LoginSubviews
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .frame(minHeight: geometry.size.height)
            }
        }
        .background(UI.color.background.primary)
        .showToast(subviews.errorToast)
    }
    
    private func content() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            header()
                .padding(.bottom, UI.spacing.lg)
            subviews
                .loginInput(TextField.Config(title: LoginStrings.loginTitle))
                .padding(.bottom, UI.spacing.lg)
            subviews
                .submitButton(Button.Config(title: LoginStrings.continueButton, isLoading: vm.isLoading))
                .padding(.bottom, UI.spacing.md)
            separator()
                .padding(.bottom, UI.spacing.md)
            subviews
                .googleOAuthButton(LoginStrings.googleButton)
                .padding(.bottom, UI.spacing.lg)
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
    
    private func register() -> some View {
        HStack {
            Spacer()
            Text(LoginStrings.registerTitle)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
            subviews.registerButton(LinkButton.Config(title: LoginStrings.registerButton))
            Spacer()
        }
    }
}

#Preview {
    LoginView(vm: .init(), subviews: .init(
        submitButton: Button.preview(),
        googleOAuthButton: GoogleAuthButton.preview(),
        loginInput: TextField.preview(value: "John Connor", error: "John Connor isn't with us yet"),
        registerButton: LinkButton.preview(),
        errorToast: Toast.preview(message: "Something went wrong...")
    ))
}

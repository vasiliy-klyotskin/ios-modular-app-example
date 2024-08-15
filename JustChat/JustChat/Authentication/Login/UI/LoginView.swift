//
//  LoginView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI
import Combine

public struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    let subviews: LoginSubviews
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .frame(minHeight: geometry.size.height)
            }
        }
        .showToast(subviews.errorToast)
    }
    
    private func content() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            headerBlock()
            subviews
                .loginInput(TextField.Config(title: LoginStrings.loginTitle))
                .padding(.bottom)
            subviews
                .submitButton(Button.Config(title: LoginStrings.continueButton, isLoading: vm.isLoading))
                .padding(.vertical)
            separator()
            subviews
                .googleOAuthButton(Button.Config(title: LoginStrings.googleButton))
                .padding(.vertical)
            registerBlock()
        }
        .disabled(vm.isLoading)
        .padding(24)
    }
    
    private func headerBlock() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LoginStrings.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(LoginStrings.subtitle)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .padding(.bottom)
        .padding(.bottom)
    }
    
    private func separator() -> some View {
        HStack(spacing: 24) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(.systemGray5))
            Text(LoginStrings.separator)
                .foregroundColor(Color(.systemGray3))
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(.systemGray5))
        }
    }
    
    private func registerBlock() -> some View {
        HStack {
            Spacer()
            Text(LoginStrings.registerTitle)
            subviews.registerButton(LinkButton.Config(title: LoginStrings.registerButton))
            Spacer()
        }
    }
}

#Preview {
    LoginView(vm: .init(), subviews: .init(
        submitButton: Button.preview(),
        googleOAuthButton: Button.preview(),
        loginInput: TextField.preview(value: "John Connor", error: "Huh?"),
        registerButton: LinkButton.preview(),
        errorToast: Toast.preview(message: "General error message")
    ))
}

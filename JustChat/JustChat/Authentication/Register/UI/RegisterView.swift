//
//  RegisterView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/17/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: RegisterViewModel
    
    private var particlesImageName: String { "figure" }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .frame(minHeight: geometry.size.height)
                    .disabled(vm.isContentDisabled)
            }
            .background(ParticlesView(size: geometry.size, imageName: particlesImageName))
            .background(UI.color.background.primary)
        }
    }
    
    private func content() -> some View {
        VStack(spacing: 0) {
            Spacer()
            BackgroundGradientSeparator()
            VStack(alignment: .leading, spacing: UI.spacing.lg) {
                header()
                inputs().padding(.vertical, UI.spacing.md)
                submitButton()
                login()
            }
            .padding(UI.spacing.md)
            .background(UI.color.background.primary)
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

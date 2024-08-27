//
//  EnterCodeView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import SwiftUI

struct EnterCodeView: View {
    @ObservedObject var vm: EnterCodeViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .padding(UI.spacing.md)
                    .frame(minHeight: geometry.size.height)
            }
        }
        .background(UI.color.background.primary)
    }
    
    private func content() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            header()
            OTPView()
            resendInfo()
            resendButton()
        }
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: UI.spacing.md) {
            Text(EnterCodeStrings.title)
                .font(UI.font.bold.largeTitle)
                .foregroundStyle(UI.color.text.primary)
            Text(EnterCodeStrings.subtitle)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.secondary)
        }
    }
    
    private func resendInfo() -> some View {
        HStack(spacing: UI.spacing.sm) {
            Text(EnterCodeStrings.resendCodeIn)
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
            Text("5:10")
                .font(UI.font.plain.body)
                .foregroundStyle(UI.color.text.primary)
        }
    }
    
    private func resendButton() -> some View {
        Button(action: vm.resendTapped, config: .standard(title: EnterCodeStrings.resendButton))
    }
}

#Preview {
    EnterCodeView(vm: .init())
}

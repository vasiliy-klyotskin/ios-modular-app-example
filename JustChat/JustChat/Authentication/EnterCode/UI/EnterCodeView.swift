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
            CodeInputView(vm: vm.codeInput).padding(.vertical, UI.spacing.md)
            resendInfo()
            resendButton()
        }
        .onAppear(perform: vm.handleViewAppear)
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
            Text(vm.timeRemainingUntilNextAttempt)
                .font(UI.font.bold.body)
                .foregroundStyle(UI.color.text.primary)
        }
        .padding(.bottom, UI.spacing.md)
        .opacity(vm.showTimeUntilNextAttempt ? 1 : 0)
    }
    
    private func resendButton() -> some View {
        Button(onTap: vm.resend, config: vm.resendButtonConfig)
    }
}

#Preview {
    let vm = EnterCodeViewModel(
        model: .init(confirmationToken: "any", otpLength: 4, nextAttemptAfter: 123),
        codeInput: .init(length: 4),
        toast: .init(),
        ticker: .init()
    )
    EnterCodeView(vm: vm)
}

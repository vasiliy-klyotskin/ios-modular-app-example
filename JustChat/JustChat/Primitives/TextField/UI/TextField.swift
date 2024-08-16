//
//  TextField.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct TextField: View {
    @ObservedObject var vm: TextFieldViewModel
    
    @ScaledMetric(wrappedValue: 16, relativeTo: .body) var iconSize: CGFloat
    let title: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: UI.spacing.sm) {
            HStack(alignment: .center) {
                textFieldBase()
                if vm.isClearButtonShown {
                    clearButton()
                }
            }
            separator()
            error()
        }
    }
    
    private func textFieldBase() -> some View {
        SwiftUI.TextField(title, text: $vm.input, prompt: prompt())
            .font(UI.font.bold.body)
            .tint(UI.color.separator.primary)
            .foregroundStyle(UI.color.text.primary)
    }
    
    private func prompt() -> Text {
        Text(placeholder)
            .font(UI.font.plain.body)
            .foregroundStyle(UI.color.text.placeholder)
    }
    
    private func clearButton() -> some View {
        SwiftUI.Button(action: vm.clear) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(UI.color.text.primary)
        }
    }
    
    private func separator() -> some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(vm.isError ? UI.color.status.error : UI.color.separator.primary)
    }
    
    @ViewBuilder
    private func error() -> some View {
        if let error = vm.error {
            Text(error)
                .font(UI.font.bold.headline)
                .foregroundColor(UI.color.status.error)
        }
    }
}

#Preview {
    let config = TextField.Config(title: "Title and Placeholder")
    return VStack(spacing: UI.spacing.lg) {
        TextField.preview(value: "", error: nil)(config)
        TextField.preview(value: "John Snow", error: nil)(config)
        TextField.preview(value: "", error: "Input error")(config)
        TextField.preview(value: "John Snow", error: "Input error")(config)
    }
    .padding(UI.spacing.md)
    .background(UI.color.background.primary)
}

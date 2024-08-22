//
//  TextField.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct TextField: View {
    @ObservedObject var vm: TextFieldViewModel
    let title: String
    
    @ScaledMetric(wrappedValue: 16, relativeTo: .body) var iconSize: CGFloat

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
        Text(title)
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
    let title = "Title"
    VStack(spacing: UI.spacing.lg) {
        TextField.preview(value: "", error: nil)(title)
        TextField.preview(value: "John Snow", error: nil)(title)
        TextField.preview(value: "", error: "Input error")(title)
        TextField.preview(value: "John Snow", error: "Input error")(title)
    }
    .padding(UI.spacing.md)
    .background(UI.color.background.primary)
}

typealias TextFieldSetup = (String) -> TextField

extension TextField {
    static func preview(value: String = "Input value", error: String? = "Input error") -> TextFieldSetup {
        let vm = TextFieldViewModel()
        vm.input = value
        vm.updateError(error)
        return { title in .init(vm: vm, title: title) }
    }
}

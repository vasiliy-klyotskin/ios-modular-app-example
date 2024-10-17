//
//  TextField.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI
import DesignScheme

public struct TextField: View {
    @ObservedObject private var vm: TextFieldViewModel
    private let title: String
    @ScaledMetric(wrappedValue: 12, relativeTo: .body) private var iconSize: CGFloat
    
    public init(vm: TextFieldViewModel, title: String) {
        self.vm = vm
        self.title = title
    }

    public var body: some View {
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
            .autocorrectionDisabled()
            .font(UI.font.bold.body)
            .tint(UI.color.separator.primary)
            .foregroundStyle(UI.color.text.primary)
            .onChange(of: vm.input) { old, new in vm.handle(oldInput: old, newInput: new) }
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
    VStack(spacing: UI.spacing.lg) {
        _preview(value: "", error: nil)
        _preview(value: "John Snow", error: nil)
        _preview(value: "", error: "Input error")
        _preview(value: "John Snow", error: "Input error")
    }
    .padding(UI.spacing.md)
    .background(UI.color.background.primary)
}

@MainActor
private func _preview(value: String, error: String?) -> TextField {
    let vm = TextFieldViewModel()
    vm.input = value
    vm.updateError(error)
    return .init(vm: vm, title: "Title")
}

//
//  OTPView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import SwiftUI

struct CodeInputView: View {
    @ObservedObject var vm: CodeInputViewModel
    @ScaledMetric(wrappedValue: 46, relativeTo: .body) var size: CGFloat
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            codeField()
            .onTapGesture {
                isFocused = true
            }
            hiddenTextField()
        }
    }
    
    private func codeField() -> some View {
        HStack {
            ForEach(0..<vm.length, id: \.self) { index in
                inputElement(index: index)
            }
        }
    }
    
    private func inputElement(index: Int) -> some View {
        RoundedRectangle(cornerRadius: UI.radius.corner.sm)
            .fill(UI.color.surface.primary)
            .frame(width: size, height: size * 1.3)
            .overlay(
                ZStack {
                    Text(vm.getCharacter(at: index))
                        .font(UI.font.bold.title)
                        .foregroundStyle(UI.color.text.primary)
                    if vm.shouldShowCursor(at: index) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 2, height: size * 0.7)
                    }
                }
            )
    }
    
    private func hiddenTextField() -> some View {
        SwiftUI.TextField("", text: $vm.codeInput)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($isFocused)
            .frame(width: 0, height: 0)
            .opacity(0)
    }
}

#Preview {
    CodeInputView(vm: .init(length: 4))
}

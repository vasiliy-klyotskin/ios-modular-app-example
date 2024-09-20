//
//  OTPView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import SwiftUI

struct CodeInputView: View {
    @ObservedObject var vm: CodeInputViewModel
    @FocusState private var isFocused: Bool
    @State private var isCursorVisibleAnimationFlag = true
    
    private var boxWidth: CGFloat { 46 }
    private var boxHeigth: CGFloat { boxWidth * 1.3 }
    private var cursorHeight: CGFloat { boxWidth * 0.7 }
    private var cursorWidth: CGFloat { 2 }
    private var cursorAnimationDuration: TimeInterval { 0.7 }
    private var dimCoef: CGFloat { 0.5 }
    
    var body: some View {
        ZStack {
            hiddenTextField()
            codeFieldWithIndicatorAndError()
        }
        .onTapGesture(perform: focusOnCodeInput)
        .onAppear(perform: focusOnCodeInput)
        .onChange(of: isFocused, vm.updateIsFocused)
    }
    
    private func codeFieldWithIndicatorAndError() -> some View {
        VStack(alignment: .leading, spacing: UI.spacing.md) {
            HStack(spacing: UI.spacing.md) {
                codeField()
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(UI.color.text.primary)
                }
            }
            if let error = vm.error {
                Text(error)
                    .font(UI.font.bold.body)
                    .foregroundStyle(UI.color.status.error)
            }
        }
    }
    
    private func codeField() -> some View {
        HStack {
            ForEach(0..<vm.length, id: \.self) { index in
                inputElement(index: index)
            }
            
        }
        .opacity(vm.isDimmed ? dimCoef : 1)
    }
    
    private func inputElement(index: Int) -> some View {
        RoundedRectangle(cornerRadius: UI.radius.corner.sm)
            .fill(UI.color.surface.primary)
            .frame(width: boxWidth, height: boxHeigth)
            .overlay(
                ZStack {
                    Text(vm.getCharacter(at: index))
                        .font(UI.font.bold.title)
                        .foregroundStyle(UI.color.text.primary)
                    if vm.shouldShowCursor(at: index) {
                        Rectangle()
                            .fill(UI.color.text.primary)
                            .frame(width: cursorWidth, height: cursorHeight)
                            .opacity(isCursorVisibleAnimationFlag ? 1 : 0)
                            .onAppear(perform: animateCursor)
                    }
                }
            )
    }
    
    private func hiddenTextField() -> some View {
        SwiftUI.TextField("", text: $vm.rawInput)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .autocorrectionDisabled()
            .focused($isFocused)
            .frame(width: 0, height: 0)
            .opacity(0)
    }
    
    private func animateCursor() {
        withAnimation(Animation.easeInOut(duration: cursorAnimationDuration).repeatForever(autoreverses: true)) {
            isCursorVisibleAnimationFlag.toggle()
        }
    }
    
    private func focusOnCodeInput() {
        if !isFocused {
            isFocused = true
        }
    }
}

#Preview {
    CodeInputView(vm: .init(length: 4))
}

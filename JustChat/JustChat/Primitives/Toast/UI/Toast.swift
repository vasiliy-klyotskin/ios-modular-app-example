//
//  Toast.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

public struct Toast: ViewModifier {
    @ObservedObject var vm: ToastViewModel
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if let message = vm.error {
                    _Toast(message: message, onTap: vm.processTap)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

private struct _Toast: View {
    let message: String
    let onTap: () -> Void
    
    public var body: some View {
        HStack {
            Text(message)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red)
        }
        .onTapGesture(perform: onTap)
    }
}

extension View {
    func showToast(_ toast: () -> Toast) -> some View {
        self.modifier(toast())
    }
}

#Preview {
    Rectangle()
        .fill()
        .ignoresSafeArea()
        .showToast(Toast.preview(message: "Some error"))
}

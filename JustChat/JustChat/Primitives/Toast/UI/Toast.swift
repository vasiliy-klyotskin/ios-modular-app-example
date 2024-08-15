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
                if let message = vm.message {
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
                    .onTapGesture(perform: vm.processTap)
                    .padding()
                }
                Spacer()
            }
        }
    }
}

extension View {
    func showToast(_ toast: () -> Toast) -> some View {
        modifier(toast())
    }
}

#Preview {
    Rectangle()
        .fill()
        .ignoresSafeArea()
        .showToast(Toast.preview(message: "Some error"))
}

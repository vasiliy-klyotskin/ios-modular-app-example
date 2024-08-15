//
//  Button.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI

struct Button: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                } else {
                    Text(title)
                    
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
            }
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack {
        Button.preview(config: .init(title: "Let's go", isLoading: false))
        Button.preview(config: .init(title: "Let's go", isLoading: true))
    }.padding()
}

//
//  TextField.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/14/24.
//

import SwiftUI
import Combine

public struct TextField: View {
    @ObservedObject var vm: TextFieldViewModel
    
    let title: String
    let placeholder: String
        
    @ScaledMetric(wrappedValue: 20, relativeTo: .body) var iconSize: CGFloat
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SwiftUI.TextField(title, text: $vm.input, prompt: prompt())
                .font(.system(size: 17))
                .fontWeight(.bold)
                if vm.isClearButtonShown {
                    SwiftUI.Button(action: vm.clear) {
                        Image(systemName: "star")
                    }
                }
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(vm.isError ? .red : Color(.systemGray5))
            
            if let error = vm.error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func prompt() -> Text {
        Text(placeholder)
            .foregroundStyle(Color(.systemGray2))
            .fontWeight(.medium)
            .font(.system(size: 17))
    }
}

#Preview {
    let config = TextField.Config(title: "Title")
    return VStack(spacing: 32) {
        TextField.preview(value: "", error: nil)(config)
        TextField.preview(value: "John Snow", error: nil)(config)
        TextField.preview(value: "", error: "Huh?")(config)
        TextField.preview(value: "John Snow", error: "Huh?")(config)
    }.padding()
}

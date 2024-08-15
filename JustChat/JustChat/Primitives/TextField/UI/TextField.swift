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
                SwiftUI.TextField(title, text: $vm.input, prompt:
                                    Text(placeholder)
                    .foregroundStyle(Color(.systemGray2))
                    .fontWeight(.medium)
                    .font(.system(size: 17))
                )
                .font(.system(size: 17))
                .fontWeight(.bold)
                if true {
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
}

#Preview {
    TextField.preview(config: .init(title: "Hello"))
        .padding()
}

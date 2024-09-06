//
//  OTPView.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import SwiftUI

struct OTPView: View {
    @ScaledMetric(wrappedValue: 46, relativeTo: .body) var size: CGFloat
    
    init(length: Int, onChange: (String) -> Void) {}
    
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: size, height: size * 1.3)
            }
        }.padding(.vertical, 56)
    }
}

#Preview {
    OTPView(length: 4, onChange: { _ in })
}

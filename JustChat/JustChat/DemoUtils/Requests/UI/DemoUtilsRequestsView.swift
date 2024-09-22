//
//  DemoUtilsRequestsView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import SwiftUI

struct DemoUtilsRequestsView: View {
    @ObservedObject var vm: DemoUtilsRequestsViewModel
    
    var body: some View {
        List(vm.items.indices, id: \.self) { index in
            requestItemView(at: index)
        }
    }
    
    private func requestItemView(at index: Int) -> some View {
        SwiftUI.Button(action: {
            vm.processTapItem(at: index)
        }) {
            requestItemContent(for: vm.items[index])
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func requestItemContent(for item: DemoUtilsRequestsViewModel.RequestViewItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                HStack {
                    Text(item.method)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(item.path)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        
    }
}

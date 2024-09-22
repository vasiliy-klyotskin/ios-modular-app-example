//
//  DemoUtilsRootView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import SwiftUI

struct DemoUtilsRootView: View {
    @ObservedObject var vm: DemoUtilsRootViewModel
    
    var body: some View {
        List {
            Text(vm.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .listRowBackground(Color.clear)

            Section {
                ForEach(vm.items.indices, id: \.self) { index in
                    rootItemView(at: index)
                }
            }
        }
    }
    
    private func rootItemView(at index: Int) -> some View {
        SwiftUI.Button(action: {
            vm.processItemTap(at: index)
        }) {
            rootItemContent(for: vm.items[index])
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func rootItemContent(for item: DemoUtilsRootViewModel.RootViewItem) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

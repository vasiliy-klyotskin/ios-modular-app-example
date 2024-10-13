//
//  DemoUtilsRequestsViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine

final class DemoUtilsRequestsViewModel: ObservableObject {
    struct RequestViewItem {
        let name: String
        let path: String
        let method: String
    }
    
    var onRequestSelected: (DemoRemoteRequestItem) -> Void = { _ in }
    
    @Published var items: [RequestViewItem]
    var navbarTitle: String { "Remote requests" }
    private let model: DemoRemoteRequests
    
    init(model: DemoRemoteRequests) {
        self.model = model
        self.items = model.items.map { .init(
            name: $0.name,
            path: "/" + $0.path,
            method: $0.method.uppercased())
        }
    }
    
    func processTapItem(at index: Int) {
        onRequestSelected(model.items[index])
    }
}

//
//  DemoUtilsRootViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine

final class DemoUtilsRootViewModel: ObservableObject {
    struct RootViewItem {
        let title: String
        let description: String
    }
    
    var onRemoteRequestsItemTap: (DemoRemoteRequests) -> Void = { _ in }
    
    @Published var items: [RootViewItem] = []
    var description: String { "The DemoUtils module is a toolkit designed to streamline the development process for developers working on features in the demo app" }
    private let model: DemoUtilsModel
    
    init(model: DemoUtilsModel) {
        self.model = model
        items.append(.init(
            title: "Remote requests",
            description: "This feature allows you to modify the behavior of API calls in your demo app"
        ))
    }
    
    func processItemTap(at index: Int) {
        switch index {
        case 0: onRemoteRequestsItemTap(model.remoteRequests)
        default: return
        }
    }
}

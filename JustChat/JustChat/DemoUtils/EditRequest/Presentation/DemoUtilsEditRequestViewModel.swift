//
//  DemoUtilsEditRequestViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine

final class DemoUtilsEditRequestViewModel: ObservableObject {
    struct ResponseViewItem: Identifiable, Hashable {
        let id: Int
        let name: String
    }
    
    @Published var responseItems: [ResponseViewItem]
    @Published var selectedItem: ResponseViewItem {
        didSet {
            model.selectedResponseIndex = selectedItem.id
        }
    }
    @Published var delayValue: Double {
        didSet {
            model.delay = delayValue
        }
    }
    
    var delayRangle: ClosedRange<Double> { 0...100 }
    var delayStep: Double = 0.2
    var responseItemsTitle: String {
        "Remote response"
    }
    var responseItemsSelectionText: String {
        "Select a remote response"
    }
    var changeDelayTitle: String {
        "Request delay"
    }
    var changeDelaySelectionText: String {
        "Current delay: \(String(format: "%.1f", delayValue))"
    }
    
    var navbarTitle: String {
        model.name
    }
    
    private let model: DemoRemoteRequestItem
    
    init(model: DemoRemoteRequestItem) {
        self.model = model
        self.responseItems = model.responses.enumerated().map { .init(id: $0, name: $1.name) }
        self.selectedItem = .init(id: model.selectedResponseIndex, name: model.selectedResponse.name)
        self.delayValue = model.delay
    }
}

//
//  DemoUtilsFlow.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine

final class DemoUtilsFlow: ObservableObject {
    enum Path: Hashable {
        case requests(Screen<DemoUtilsRequestsFeature>)
        case editRequest(Screen<DemoUtilsEditRequestFeature>)
    }
    
    struct Factory {
        let root: () -> DemoUtilsRootFeature
        let requests: (DemoRemoteRequests) -> DemoUtilsRequestsFeature
        let editRequest: (DemoRemoteRequestItem) -> DemoUtilsEditRequestFeature
    }
    
    @Published var isSheetPresented = false
    @Published var path: [Path] = []
    lazy var root: DemoUtilsRootFeature = { factory.root() }()
    var navbarTitle: String { "Demo Utils" }
    private let factory: Factory
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    func openDemoUtils() {
        isSheetPresented = true
    }
    
    func goToRequests(model: DemoRemoteRequests) {
        let requestsScreen = Screen(feature: factory.requests(model))
        path.append(.requests(requestsScreen))
    }
    
    func goToEditRequest(model: DemoRemoteRequestItem) {
        let editRequestScreen = Screen(feature: factory.editRequest(model))
        path.append(.editRequest(editRequestScreen))
    }
}

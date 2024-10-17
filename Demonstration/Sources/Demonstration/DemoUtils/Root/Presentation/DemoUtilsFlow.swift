//
//  DemoUtilsFlow.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine

public final class DemoUtilsFlow: ObservableObject {
    enum Path: Hashable {
        case requests(Screen<DemoUtilsRequestsFeature>)
        case editRequest(Screen<DemoUtilsEditRequestFeature>)
    }
    
    struct Factory {
        let root: () -> DemoUtilsMainFeature
        let requests: (DemoRemoteRequests) -> DemoUtilsRequestsFeature
        let editRequest: (DemoRemoteRequestItem) -> DemoUtilsEditRequestFeature
    }
    
    @Published var isSheetPresented = false
    @Published var path: [Path] = []
    lazy var root: DemoUtilsMainFeature = { factory.root() }()
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

import Foundation

struct Screen<T>: Identifiable, Hashable {
    let id = UUID()
    let feature: T
    
    static func screen(_ feature: T) -> Screen<T> {
        .init(feature: feature)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Screen<T>, rhs: Screen<T>) -> Bool {
        lhs.id == rhs.id
    }
}

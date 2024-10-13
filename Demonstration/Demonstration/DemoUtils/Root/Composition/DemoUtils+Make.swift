//
//  DemoUtils+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Combine
import Foundation
import CompositionSupport
import Networking

extension DemoUtilsFeature {
    public static func make(model: DemoUtilsModel) -> DemoUtilsFeature {
        let weakFlow = Weak<DemoUtilsFlow>()
        let rootEvents = DemoUtilsMainEvents(onRequestsSelection: weakFlow.do { $0.goToRequests })
        let requestsEvents = DemoUtilsRequestsEvents(onRequestSelected: weakFlow.do { $0.goToEditRequest })
        let flow = DemoUtilsFlow(factory: .init(
            root: DemoUtilsMainFeature.make <~ rootEvents <~ model,
            requests: DemoUtilsRequestsFeature.make <~ requestsEvents,
            editRequest: DemoUtilsEditRequestFeature.make
        ))
        let remoteClient = remote <~ model.remoteRequests
        weakFlow.obj = flow
        return .init(flow: flow, remoteClient: remoteClient)
    }
    
    public func view() -> DemoUtilsView {
        .init(flow: flow)
    }
    
    private static func remote(
        for model: DemoRemoteRequests,
        request: RemoteRequest
    ) -> AnyPublisher<RemoteResponse, Error> {
        model.getResponse(for: request)
            .publisher
            .delay(for: model.getDelay(for: request), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

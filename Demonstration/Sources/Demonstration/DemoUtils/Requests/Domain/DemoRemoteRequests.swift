//
//  DemoRemoteRequests.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import Foundation
import Networking

public struct DemoRemoteRequests {
    struct ResponseNotFound: Error {}
    
    let items: [DemoRemoteRequestItem]
    private var defaultDelay: Double { 1 }
    
    public init(_ items: [DemoRemoteRequestItem]) {
        self.items = items
    }

    func getResponse(for request: RemoteRequest) -> Result<RemoteResponse, Error> {
        if let item = item(for: request) {
            return item.selectedResponse.remoteResponse
        } else {
            return .failure(ResponseNotFound())
        }
    }
    
    func getDelay(for request: RemoteRequest) -> DispatchQueue.SchedulerTimeType.Stride {
        if let item = item(for: request) {
            return .seconds(item.delay)
        } else {
            return .seconds(defaultDelay)
        }
    }
    
    private func item(for request: RemoteRequest) -> DemoRemoteRequestItem? {
        items.first(where: { $0.path == request.path && $0.method == request.method })
    }
}

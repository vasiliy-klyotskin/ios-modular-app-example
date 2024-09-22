//
//  DemoUtilsRootFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

typealias DemoUtilsRootFeature = DemoUtilsRootViewModel

struct DemoUtilsRootEvents {
    let onRequestsSelection: (DemoRemoteRequests) -> Void
}

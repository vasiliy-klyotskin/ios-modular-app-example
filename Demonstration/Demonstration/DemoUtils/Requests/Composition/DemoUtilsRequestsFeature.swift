//
//  DemoUtilsRequestsFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

typealias DemoUtilsRequestsFeature = DemoUtilsRequestsViewModel

struct DemoUtilsRequestsEvents {
    let onRequestSelected: (DemoRemoteRequestItem) -> Void
}

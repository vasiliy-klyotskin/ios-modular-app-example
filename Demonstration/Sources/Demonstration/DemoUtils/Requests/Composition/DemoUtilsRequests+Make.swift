//
//  DemoUtilsRequests+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

extension DemoUtilsRequestsFeature {
    static func make(
        events: DemoUtilsRequestsEvents,
        model: DemoRemoteRequests
    ) -> DemoUtilsRequestsFeature {
        let vm = DemoUtilsRequestsViewModel(model: model)
        vm.onRequestSelected = events.onRequestSelected
        return vm
    }
    
    func view() -> DemoUtilsRequestsView {
        .init(vm: self)
    }
}

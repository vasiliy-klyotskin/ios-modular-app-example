//
//  DemoUtilsRoot+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

extension DemoUtilsRootFeature {
    static func make(
        events: DemoUtilsRootEvents,
        model: DemoUtilsModel
    ) -> DemoUtilsRootViewModel {
        let vm = DemoUtilsRootViewModel(model: model)
        vm.onRemoteRequestsItemTap = events.onRequestsSelection
        return vm
    }
    
    func view() -> DemoUtilsRootView {
        .init(vm: self)
    }
}

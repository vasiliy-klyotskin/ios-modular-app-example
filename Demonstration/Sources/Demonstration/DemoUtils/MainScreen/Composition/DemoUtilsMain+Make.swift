//
//  DemoUtilsMain+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

extension DemoUtilsMainFeature {
    static func make(
        events: DemoUtilsMainEvents,
        model: DemoUtilsModel
    ) -> DemoUtilsMainViewModel {
        let vm = DemoUtilsMainViewModel(model: model)
        vm.onRemoteRequestsItemTap = events.onRequestsSelection
        return vm
    }
    
    func view() -> DemoUtilsMainView {
        .init(vm: self)
    }
}

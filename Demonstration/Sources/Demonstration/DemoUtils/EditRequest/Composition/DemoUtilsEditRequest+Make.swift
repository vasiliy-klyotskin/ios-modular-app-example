//
//  DemoUtilsEditRequest+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

extension DemoUtilsEditRequestFeature {
    static func make(model: DemoRemoteRequestItem) -> Self {
        .init(model: model)
    }
    
    func view() -> DemoUtilsEditRequestView {
        .init(vm: self)
    }
}

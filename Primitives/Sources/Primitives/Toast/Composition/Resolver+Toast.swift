//
//  Resolver+Toast.swift
//  Primitives
//
//  Created by Василий Клецкин on 10/9/24.
//

import CompositionSupport

extension Resolver {
    public var defaultAppToast: ToastFeature {
        self.get(ToastFeature.self)
    }
}

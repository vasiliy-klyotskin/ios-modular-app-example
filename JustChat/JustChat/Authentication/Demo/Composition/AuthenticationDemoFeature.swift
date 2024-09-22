//
//  AuthenticationDemoFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

struct AuthenticationDemoFeature {
    let vm: AuthenticationDemoViewModel
    let authentication: AuthenticationFeature
    let demoUtils: DemoUtilsFeature
    let toast: ToastFeature
}

struct AuthenticationDemoEvents {
    let onNeedToRestartDemo: () -> Void
}

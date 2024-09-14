//
//  Authentication+Feature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Foundation

struct AuthenticationFeature {
    let flow: AuthenticationFlow
    let login: () -> LoginFeature
    let register: () -> RegisterFeature
    let enterCode: (EnterCodeResendModel) -> EnterCodeFeature
}

struct AuthenticationEvents {
    
}

struct AuthenticationEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
    let makeTimer: MakeTimer
}

extension AuthenticationEnvironment {
    var login: LoginEnvironment {
        .init(httpClient: httpClient, scheduler: scheduler)
    }
    
    var register: RegisterEnvironment {
        .init(httpClient: httpClient, scheduler: scheduler)
    }
    
    var enterCode: EnterCodeEnvironment {
        .init(httpClient: httpClient, scheduler: scheduler, makeTimer: makeTimer)
    }
}

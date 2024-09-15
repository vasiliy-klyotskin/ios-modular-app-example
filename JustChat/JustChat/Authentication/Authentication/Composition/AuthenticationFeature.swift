//
//  Authentication+Feature.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/9/24.
//

import Foundation

typealias AuthenticationFeature = AuthenticationFlow

struct AuthenticationEvents {
    let onSuccess: () -> Void
}

struct AuthenticationEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
    let makeTimer: MakeTimer
    let storage: KeychainStorage
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

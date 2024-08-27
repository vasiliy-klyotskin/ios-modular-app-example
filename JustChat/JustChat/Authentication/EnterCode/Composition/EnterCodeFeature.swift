//
//  EnterCodeFeature.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Foundation

typealias EnterCodeFeature = EnterCodeViewModel

struct EnterCodeEnvironment {
    let httpClient: RemoteClient
    let scheduler: AnySchedulerOf<DispatchQueue>
}

struct EnterCodeEvents {
    let onCorrectOtpEnter: (EnterCodeModel) -> Void
}

//
//  AuthenticationDemo+Make.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import Foundation
import AuthenticationServices
import Primitives
import Authentication
import Networking
import Demonstration
import CompositionSupport

extension AuthenticationDemoFeature {
    static func make(events: AuthenticationDemoEvents) -> AuthenticationDemoFeature {
        let toast = ToastFeature.make(uiScheduler: .main)
        let demoUtils = DemoUtilsFeature.make(
            model: .init(remoteRequests: .init(requestsItems()))
        )
        let container = makeContainer(
            toast: toast,
            demoUtils: demoUtils
        )
        let vm = AuthenticationDemoViewModel()
        let authentication = AuthenticationFeature.make(
            env: .from(resolver: container),
            events: .init(onSuccess: vm.showSuccess)
        )
        vm.onNeedRestart = events.onNeedToRestartDemo
        return .init(vm: vm, authentication: authentication, demoUtils: demoUtils, toast: toast)
    }
    
    func view() -> AuthenticationDemoView {
        .init(vm: vm, authentication: authentication, demoUtils: demoUtils, toast: toast)
    }
    
    private static func requestsItems() -> [DemoRemoteRequestItem] {
        [
            .init(
                name: "Login submit",
                path: LoginRequest.path,
                method: LoginRequest.method,
                responses: [
                    .success(name: "Success", LoginData.successResponse(token: "any", otpLength: 4)),
                    .success(name: "General error", LoginData.generalError("General error")),
                    .success(name: "Validation error", LoginData.inputError("Validation error")),
                    .failure(name: "Request failure")
                ]
            ),
            .init(
                name: "Registration submit",
                path: RegisterRequest.path,
                method: RegisterRequest.method,
                responses: [
                    .success(name: "Success", RegisterData.successResponse(token: "any", otpLength: 4)),
                    .success(name: "Validation error (email, username)", RegisterData.validationErrorResponse(email: "Email validation error", username: "Username validation error")),
                    .success(name: "General error", RegisterData.generalErrorResponse(message: "Registration general error"))
                ]
            ),
            .init(
                name: "Code submit",
                path: EnterCodeSubmitRequest.path,
                method: EnterCodeSubmitRequest.method,
                responses: [
                    .success(name: "Success", EnterCodeData.successSubmitResponse(accessToken: "abc123", refreshToken: "qwe456")),
                    .success(name: "General error", EnterCodeData.submitGeneralError("Submit code general error")),
                    .success(name: "Validation error", EnterCodeData.submitValidationError("Submit code validation error"))
                ]
            ),
            .init(
                name: "Code resend",
                path: EnterCodeResendRequest.path,
                method: EnterCodeResendRequest.method,
                responses: [
                    .success(name: "Success", EnterCodeData.successResendResponse(token: "any", otpLength: 4)),
                    .success(name: "General error", EnterCodeData.resendGeneralError("Resend code general error"))
                ]
            ),
            .init(
                name: "OAuth tokens request",
                path: OAuthRequest.path,
                method: OAuthRequest.method,
                responses: [
                    .success(name: "Success", OAuthData.successResponse(accessToken: "asd321", refreshToken: "vcx789")),
                    .success(name: "General error", OAuthData.generalErrorResponse(message: "OAuth general error"))
                ]
            ),
        ]
    }
    
    private static func makeContainer(
        toast: ToastFeature,
        demoUtils: DemoUtilsFeature
    ) -> Container {
        Container()
            .register(AppInfo.self, .init(bundleId: Bundle.main.bundleIdentifier ?? ""))
            .register(RemoteClient.self, demoUtils.remoteClient)
            .register(AnySchedulerOf<DispatchQueue>.self, .main)
            .register(ToastFeature.self, toast)
            .register(MakeTimer.self, Timer.scheduledOnMainRunLoop)
            .register(MakeAuthSession.self, ASWebAuthenticationSession.init)
            .register(KeychainStorage.self, .init(service: "Authentication"))
    }
}

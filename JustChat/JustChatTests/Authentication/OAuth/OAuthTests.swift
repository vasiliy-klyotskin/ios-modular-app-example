//
//  OAuthTests.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

import Testing
import Foundation
@testable import JustChat

@Suite final class OAuthTests {
    @Test func loadingIndicator() {
        let (sut, spy) = makeSut()
        #expect(spy.isLoadingIndicatorVisible == false, "Loading indicator should be hidden initially.")
        
        sut.simulateGoogleSignIn()
        #expect(spy.isLoadingIndicatorVisible == false, "Loading indicator should be hidden after web session starts.")
        
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "any"))
        #expect(spy.isLoadingIndicatorVisible == true, "Loading indicator should be displayed after web session returns the url.")
        
        spy.finishRemoteWithError(index: 0)
        #expect(spy.isLoadingIndicatorVisible == false, "Loading indicator should be hidden after receiving an error.")
        
        sut.simulateGoogleSignIn()
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "any"))
        spy.finishRemoteWith(response: TestData.successResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.isLoadingIndicatorVisible == false, "Loading indicator should be hidden after receiving a success.")
    }
    
    @Test func generalError() {
        let (sut, spy) = makeSut()
        #expect(spy.generalError == nil, "General error should be hidden initially.")
        
        sut.simulateGoogleSignIn()
        #expect(spy.generalError == nil, "General error should be hidden after web session starts.")
        
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "any"))
        #expect(spy.generalError == nil, "General error should be hidden after web session returns the url.")
        
        spy.finishRemoteWith(response: TestData.generalErrorResponse(message: "general message"), index: 0)
        #expect(spy.generalError == "general message", "General error should be displayed after receiving an error.")
        
        sut.simulateGoogleSignIn()
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "any"))
        #expect(spy.generalError == nil, "General error should be hidden after session return the url.")
        
        spy.finishRemoteWith(response: TestData.successResponse(accessToken: "any", refreshToken: "any"), index: 1)
        #expect(spy.generalError == nil, "General error should be hidden after receiving a success.")
    }
    
    @Test func tokensRequest() {
        let (sut, spy) = makeSut()
        #expect(spy.remote.requests.isEmpty, "There should not be a request initially.")
        
        sut.simulateGoogleSignIn()
        #expect(spy.remote.requests.isEmpty, "There should not be a request after user initiates google sign in.")
        
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "abc123"))
        expectRequestIsCorrect(spy.remote.requests[0], authCode: "abc123", "There should be a request after the auth code is received from web session.")
        
        spy.finishRemoteWith(response: TestData.successResponse(accessToken: "any", refreshToken: "any"), index: 0)
        #expect(spy.remote.requests.count == 1, "There should not be a new request after receiving success.")
    }
    
    @Test func successMessage() {
        let (sut, spy) = makeSut()
        #expect(spy.successes.isEmpty, "There should not be a success message initially.")
        
        sut.simulateGoogleSignIn()
        #expect(spy.successes.isEmpty, "There should not be a success message after the user initiates the session.")
        
        spy.session.finishWIth(url: TestData.redirectUrlWith(code: "any"))
        #expect(spy.successes.isEmpty, "There should not be a success message after the session is completed.")
        
        spy.finishRemoteWith(response: TestData.successResponse(accessToken: "access", refreshToken: "refresh"), index: 0)
        #expect(spy.successes == [.init(accessToken: "access", refreshToken: "refresh")], "There should be a success message after receiving success")
    }
    
    @Test func authUrlIsCorrect() {
        let (sut, spy) = makeSut(bundleId: "my_bundle_id")
        sut.simulateGoogleSignIn()
        #expect(spy.session.url == URL(string: "https://accounts.google.com/o/oauth2/v2/auth?client_id=1039760114726-oq2kkgr72o78jvb68uvotc9vqnnrfc94.apps.googleusercontent.com&redirect_uri=my_bundle_id:/any-path&response_type=code&scope=openid%20profile%20email")!)
    }

    // MARK: - Helpers
    
    typealias Sut = OAuthFeature
    typealias TestData = OAuthData
    
    private let leakChecker = MemoryLeakChecker()
    
    private func makeSut(bundleId: String = "", _ loc: SourceLocation = #_sourceLocation) -> (Sut, OAuthSpy) {
        let spy = OAuthSpy()
        let env = OAuthEnvironment(
            remoteClient: spy.remote.load,
            uiScheduler: spy.uiScheduler.eraseToAnyScheduler(),
            toast: .init(),
            appInfo: .init(bundleId: bundleId),
            makeAuthSession: spy.session.makeSession
        )
        let events = OAuthEvents(onSuccess: spy.keepSuccess)
        let sut = OAuthFeature.make(env: env, events: events)
        spy.startSpying(sut: sut)
        leakChecker.addForChecking(sut, spy, spy.remote, sourceLocation: loc)
        return (sut, spy)
    }
}

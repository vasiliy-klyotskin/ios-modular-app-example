//
//  OAuthService.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/16/24.
//

import AuthenticationServices

typealias MakeAuthSession = (
    _ url: URL,
    _ callback: ASWebAuthenticationSession.Callback,
    _ completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler
) -> ASWebAuthenticationSession

final class OAuthService {
    private let provider: ASWebAuthenticationPresentationContextProviding
    private let makeAuthSession: MakeAuthSession
    private let bundleId: String
    
    var onGoogleSignInSuccess: (OAuthRequest) -> Void = { _ in }
    
    private var authSession: ASWebAuthenticationSession?
    
    init(
        provider: ASWebAuthenticationPresentationContextProviding,
        bundleId: String,
        makeAuthSession: @escaping MakeAuthSession
    ) {
        self.provider = provider
        self.bundleId = bundleId
        self.makeAuthSession = makeAuthSession
    }
    
    func startGoogleSignIn() {
        guard let authURL = createGoogleURL() else { return }
        let callback = ASWebAuthenticationSession.Callback.customScheme(bundleId)
        authSession = makeAuthSession(authURL, callback) { [weak self] callbackURL, _ in
            if let callbackURL = callbackURL {
                self?.handleGoogleSignInSuccess(url: callbackURL)
            }
        }
        authSession?.presentationContextProvider = provider
        authSession?.start()
    }
    
    private func createGoogleURL() -> URL? {
        let redirectUri = "\(bundleId):/any-path"
        let baseURL = "https://accounts.google.com/o/oauth2/v2/auth"
        let clientId = "1039760114726-oq2kkgr72o78jvb68uvotc9vqnnrfc94.apps.googleusercontent.com"
        let scope = "openid profile email"
        let queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope)
        ]
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    private func handleGoogleSignInSuccess(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        guard let queryItems = components.queryItems else { return }
        for item in queryItems where item.name == "code" {
            guard let authCode = item.value else { continue }
            onGoogleSignInSuccess(.init(authCode: authCode))
            return
        }
    }
}

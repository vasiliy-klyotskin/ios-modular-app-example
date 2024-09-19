//
//  AuthSessionSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

import AuthenticationServices

final class AuthSessionSpy: ASWebAuthenticationSession {
    private var completionHandler: CompletionHandler?
    var url: URL?
    
    convenience init() {
        self.init(url: URL(string: "https://any.com")!, callback: .customScheme("any"), completionHandler: { _, _ in })
    }
    
    override func start() -> Bool {
        return true
    }
    
    func finishWIth(url: String) {
        completionHandler?(URL(string: url)!, nil)
    }
    
    func makeSession(
        url: URL,
        callback: Callback,
        completionHandler: @escaping CompletionHandler
    ) -> ASWebAuthenticationSession {
        self.completionHandler = completionHandler
        self.url = url
        return self
    }
}

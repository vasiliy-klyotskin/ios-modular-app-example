//
//  OAuth+Checks.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/17/24.
//

@testable import JustChat
import Testing

extension OAuthTests {
    func expectRequestIsCorrect(_ request: RemoteRequest, authCode: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == OAuthRequest.path, comment, sourceLocation: sourceLocation)
        #expect(request.method == OAuthRequest.method, comment, sourceLocation: sourceLocation)
        #expect(request.dto() == OAuthRequestDTO(authCode: authCode), comment, sourceLocation: sourceLocation)
    }
}
